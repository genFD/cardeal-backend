import { Test, TestingModule } from '@nestjs/testing';
import { UsersController } from '../../users.controller';
import { UsersService } from '../../users.service';
import { createUserStub } from '../stubs/user.stub';
import { Users } from '../../entities/user.entity';
import { CreateUserDto } from '../../dto/create-user.dto';
import { UpdateUserDto } from '../../dto/update-user.dto';

jest.mock('../../users.service');

describe('UsersController', () => {
  let controller: UsersController;
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  let service: UsersService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [],
      controllers: [UsersController],
      providers: [UsersService],
    }).compile();

    controller = module.get<UsersController>(UsersController);
    service = module.get<UsersService>(UsersService);
    jest.clearAllMocks();
  });
  describe('Find user', () => {
    describe('When findOne is called ', () => {
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      let user: Users;
      beforeEach(async () => {
        user = await controller.findOne(createUserStub().id);
      });

      test('then it should call usersService', () => {
        expect(service.findOneById).toBeCalledWith(createUserStub().id);
      });

      test('then it should return a user', () => {
        expect(user).toEqual(createUserStub());
      });
    });
  });

  describe('Find user by email', () => {
    describe('When findOneByEmail is called ', () => {
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      let user: Users;
      beforeEach(async () => {
        user = await controller.findOneByEmail(createUserStub().email);
      });

      test('then it should call usersService', () => {
        expect(service.findOneByEmail).toBeCalledWith(createUserStub().email);
      });

      test('then it should return a user', () => {
        expect(user).toEqual(createUserStub());
      });
    });
  });

  describe('Find users', () => {
    describe('When findAll is called ', () => {
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      let users: Users[];
      beforeEach(async () => {
        users = await controller.findAll();
      });

      test('then it should call usersService', () => {
        expect(service.findAll).toHaveBeenCalled();
      });

      test('then it should return a list of users', () => {
        expect(users).toEqual([createUserStub()]);
      });
    });
  });

  describe('Create a user', () => {
    describe('When create is called ', () => {
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      let user: Users;
      let body: CreateUserDto;
      beforeEach(async () => {
        body = {
          email: createUserStub().email,
          password: createUserStub().password,
        };
        user = await controller.create(body);
      });

      test('then it should call usersService', () => {
        expect(service.create).toHaveBeenCalledWith(body.email, body.password);
      });

      test('then it should return a user', () => {
        expect(user).toEqual(createUserStub());
      });
    });
  });

  describe('Update a user', () => {
    describe('When update is called ', () => {
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      let user: Users;
      let id: string;
      let data: UpdateUserDto;
      beforeEach(async () => {
        data = {
          email: createUserStub().email,
          password: createUserStub().password,
        };
        id = createUserStub().id;
        user = await controller.update(id, data);
      });

      test('then it should call usersService', () => {
        expect(service.update).toHaveBeenCalledWith(id, data);
      });

      test('then it should return a user', () => {
        expect(user).toEqual(createUserStub());
      });
    });
  });

  describe('Remove a user', () => {
    describe('When remove is called ', () => {
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      let user: Users;
      beforeEach(async () => {
        user = await controller.remove(createUserStub().id);
      });

      test('then it should call usersService', () => {
        expect(service.remove).toBeCalledWith(createUserStub().id);
      });

      test('then it should return a user', () => {
        expect(user).toEqual(createUserStub());
      });
    });
  });
});
