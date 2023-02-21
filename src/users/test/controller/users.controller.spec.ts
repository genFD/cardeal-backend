import { Test, TestingModule } from '@nestjs/testing';
import { UsersController } from '../../users.controller';
import { UsersService } from '../../users.service';
import { createUserStub } from '../stubs/user.stub';

import { NotFoundException } from '@nestjs/common';

jest.mock('../../users.service');

describe('UsersController Tests', () => {
  let usersController: UsersController;
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  let userService: UsersService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [],
      controllers: [UsersController],
      providers: [UsersService],
    }).compile();

    usersController = module.get<UsersController>(UsersController);
    userService = module.get<UsersService>(UsersService);
    jest.clearAllMocks();
  });

  afterEach(() => {
    jest.clearAllMocks();
  });
  describe('UsersController', () => {
    it('can create an instance of UsersController', async () => {
      expect(usersController).toBeDefined();
    });
  });

  describe('findAll()', () => {
    it('returns a list of users', async () => {
      const users = await usersController.findAll();
      expect(users.length).toEqual(1);
    });
  });

  describe('finOne()', () => {
    it('throws an error if called with an id that does not exist', async () => {
      await expect(usersController.findOne('1')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('finOne()', () => {
    it('returns a single user with the given id', async () => {
      const user = await usersController.findOne(createUserStub().id);
      expect(user).toBeDefined();
    });
  });

  // describe('Find user by email', () => {
  //   describe('When findOneByEmail is called ', () => {
  //     // eslint-disable-next-line @typescript-eslint/no-unused-vars
  //     let user: Users;
  //     beforeEach(async () => {
  //       user = await controller.findOneByEmail(createUserStub().email);
  //     });

  //     test('then it should call usersService', () => {
  //       expect(service.findOneByEmail).toBeCalledWith(createUserStub().email);
  //     });

  //     test('then it should return a user', () => {
  //       expect(user).toEqual(createUserStub());
  //     });
  //   });
  // });

  // describe('Find users', () => {
  //   describe('When findAll is called ', () => {
  //     // eslint-disable-next-line @typescript-eslint/no-unused-vars
  //     let users: Users[];
  //     beforeEach(async () => {
  //       users = await controller.findAll();
  //     });

  //     test('then it should call usersService', () => {
  //       expect(service.findAll).toHaveBeenCalled();
  //     });

  //     test('then it should return a list of users', () => {
  //       expect(users).toEqual([createUserStub()]);
  //     });
  //   });
  // });

  // describe('Create a user', () => {
  //   describe('When create is called ', () => {
  //     // eslint-disable-next-line @typescript-eslint/no-unused-vars
  //     let user: Users;
  //     let body: CreateUserDto;
  //     beforeEach(async () => {
  //       body = {
  //         email: createUserStub().email,
  //         password: createUserStub().password,
  //       };
  //       user = await controller.create(body);
  //     });

  //     test('then it should call usersService', () => {
  //       expect(service.create).toHaveBeenCalledWith(body.email, body.password);
  //     });

  //     test('then it should return a user', () => {
  //       expect(user).toEqual(createUserStub());
  //     });
  //   });
  // });

  // describe('Update a user', () => {
  //   describe('When update is called ', () => {
  //     // eslint-disable-next-line @typescript-eslint/no-unused-vars
  //     let user: Users;
  //     let id: string;
  //     let data: UpdateUserDto;
  //     beforeEach(async () => {
  //       data = {
  //         email: createUserStub().email,
  //         password: createUserStub().password,
  //       };
  //       id = createUserStub().id;
  //       user = await controller.update(id, data);
  //     });

  //     test('then it should call usersService', () => {
  //       expect(service.update).toHaveBeenCalledWith(id, data);
  //     });

  //     test('then it should return a user', () => {
  //       expect(user).toEqual(createUserStub());
  //     });
  //   });
  // });

  // describe('Remove a user', () => {
  //   describe('When remove is called ', () => {
  //     // eslint-disable-next-line @typescript-eslint/no-unused-vars
  //     let user: Users;
  //     beforeEach(async () => {
  //       user = await controller.remove(createUserStub().id);
  //     });

  //     test('then it should call usersService', () => {
  //       expect(service.remove).toBeCalledWith(createUserStub().id);
  //     });

  //     test('then it should return a user', () => {
  //       expect(user).toEqual(createUserStub());
  //     });
  //   });
  // });
});
