import { createUserStub } from '../test/stubs/user.stub';

export const UsersService = jest.fn().mockReturnValue({
  findAll: jest.fn().mockResolvedValue([createUserStub()]),

  findOneById: jest.fn().mockResolvedValue(createUserStub()),

  findOneByEmail: jest.fn().mockResolvedValue(createUserStub()),

  create: jest.fn().mockResolvedValue(createUserStub()),

  update: jest.fn().mockResolvedValue(createUserStub()),

  remove: jest.fn().mockResolvedValue(createUserStub()),
});
