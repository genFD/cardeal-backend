import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from '../../auth.controller';
import { AuthService } from '../../auth.service';
import { UsersService } from '../../../users/users.service';
import { createUserStub } from '../../../users/test/stubs/user.stub';
import { NotFoundException, BadRequestException } from '@nestjs/common';

jest.mock('../../../users/users.service');

describe('AuthController unit tests', () => {
  let authController: AuthController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [AuthService, UsersService],
    }).compile();

    authController = module.get<AuthController>(AuthController);
  });

  describe('AuthController', () => {
    it('should be defined', () => {
      expect(authController).toBeDefined();
    });
  });

  describe('signin()', () => {
    it('updates session object and returns a user', async () => {
      const body = {
        email: createUserStub().email,
        password: createUserStub().password,
      };
      const session = { userId: '' };

      const user = await authController.signin(body, session);

      expect(session.userId).toEqual(user.id);
      expect(user).toBeDefined();
    });
  });

  describe('signin()', () => {
    it('throws an error if called with incorrect email or password', async () => {
      const body = {
        email: 'wrongemail@email.com',
        password: 'wrongpassword',
      };
      const session = { userId: '' };

      expect(session.userId).toEqual('');
      await expect(authController.signin(body, session)).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('signup()', () => {
    it('updates session object and returns a new user', async () => {
      const body = {
        email: 'newuseremail@email.com',
        password: 'newpassword',
      };
      const session = { userId: '' };

      const user = await authController.signup(body, session);

      expect(session.userId).toEqual(user.id);
      expect(user).toBeDefined();
    });
  });

  describe('signup()', () => {
    it('throws an error if called with email or password in use', async () => {
      const body = {
        email: createUserStub().email,
        password: createUserStub().password,
      };
      const session = { userId: '' };

      expect(session.userId).toEqual('');
      await expect(authController.signup(body, session)).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('logout()', () => {
    it('updates session object', async () => {
      const session = { userId: 'userId' };
      await authController.logout(session);
      expect(session.userId).toEqual(null);
    });
  });

  describe('whoAmI()', () => {
    it('returns the current user', async () => {
      const currentUser = createUserStub();
      const user = authController.whoAmI(currentUser);
      expect(user.email).toEqual(currentUser.email);
    });
  });
});
