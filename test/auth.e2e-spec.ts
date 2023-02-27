import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';
// import { setupApp } from '../src/setup-app';
import * as bcrypt from 'bcrypt';
import prisma from './prisma';

describe('Authentication (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    // setupApp(app);
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('[POST] signup()', () => {
    it('should respond with a `201` status code and user details', async () => {
      const email = 'emaildev5@example.com';
      const { status, body } = await request(app.getHttpServer())
        .post('/auth/signup')
        .send({ email, password: 'testpassword' });
      const newUser = await prisma.user.findFirst();
      // console.log(newUser);
      expect(newUser).not.toBeNull();
      expect(status).toBe(201);
      expect(body.email).toEqual(email);
    });

    it('should respond with a valid session object when successful', async () => {
      const email = 'emailv1@example.com';
      const res = await request(app.getHttpServer())
        .post('/auth/signup')
        .send({ email, password: 'testpassword' })
        .expect(201);

      const session = res.get('Set-Cookie');
      const { body } = await request(app.getHttpServer())
        .get('/auth/whoami')
        .set('Cookie', session)
        .expect(200);

      expect(body.email).toEqual(email);
    });

    it('should respond with a `400` status code if a user exists with the provided username', async () => {
      const email = 'emailv2x@example.com';
      const password = 'password';

      await prisma.user.create({
        data: {
          email,
          password,
        },
      });
      const { status, body } = await request(app.getHttpServer())
        .post('/auth/signup')
        .send({ email, password });

      const count = await prisma.user.count();

      expect(status).toBe(400);

      expect(count).toBe(1);

      expect(body).not.toHaveProperty('user');
    });

    it('should respond with a `400` status code if an invalid request body is provided', async () => {
      const username = 'emailv3x@example.com'; // should be email
      const password = 'password';

      const { status, body } = await request(app.getHttpServer())
        .post('/auth/signup')
        .send({ username, password });

      expect(status).toBe(400);

      expect(body.message[0]).toBe('email must be an email');
    });
  });

  describe('[POST] signin()', () => {
    const user = { email: 'gil@gil.com', password: 'testpassword' };
    beforeEach(async () => {
      await prisma.user.create({
        data: {
          email: user.email,
          password: await bcrypt.hash(user.password, 10),
        },
      });
    });

    it('should respond with a `201` status code when provided valid credentials', async () => {
      const { status } = await request(app.getHttpServer())
        .post('/auth/signin')
        .send({
          email: user.email,
          password: user.password,
        });

      expect(status).toBe(201);
    });

    it('should respond with the user details when successful', async () => {
      const { body } = await request(app.getHttpServer())
        .post('/auth/signin')
        .send({
          email: user.email,
          password: user.password,
        });
      const keys = Object.keys(body);

      expect(keys.length).toBe(2);

      expect(keys).toStrictEqual(['id', 'email']);

      expect(body.email).toBe(user.email);
    });

    it('should respond with a valid session token when successful', async () => {
      const res = await request(app.getHttpServer()).post('/auth/signin').send({
        email: user.email,
        password: user.password,
      });
      const session = res.get('Set-Cookie');
      const { body } = await request(app.getHttpServer())
        .get('/auth/whoami')
        .set('Cookie', session)
        .expect(200);

      expect(body.email).toEqual(user.email);
    });

    it('should respond with a `400` status code when given invalid credentials', async () => {
      const { body, status } = await request(app.getHttpServer())
        .post('/auth/signin')
        .send({
          email: user.email,

          password: 'wrongpassword',
        });

      expect(status).toBe(400);

      expect(body).not.toHaveProperty('email');
    });

    it('should respond with a `404` status code when the user cannot be found', async () => {
      const { body, status } = await request(app.getHttpServer())
        .post('/auth/signin')
        .send({
          email: 'wrongemail@email.com',

          password: user.password,
        });
      expect(status).toBe(404);
      expect(body).not.toHaveProperty('email');
    });

    it('should respond with a `400` status code when given an invalid request body', async () => {
      const { body, status } = await request(app.getHttpServer())
        .post('/auth/signin')
        .send({
          username: 'username', // should be email

          password: user.password,
        });
      expect(status).toBe(400);
      expect(body).not.toHaveProperty('email');
    });
  });
});
