import { createUserStub } from '../test/stubs/user.stub';

export const UsersService = jest.fn().mockReturnValue({
  findAll: jest.fn().mockResolvedValue([createUserStub()]),

  findOneById: jest.fn().mockResolvedValue(createUserStub()),

  findOneByEmail: jest.fn((email: string) => {
    if (email === createUserStub().email) {
      return Promise.resolve(createUserStub());
    }
  }),

  create: jest.fn((email: string, password: string) => {
    const user = {
      id: Math.floor(Math.random() * 99).toString(),
      email: email,
      password: password,
      admin: false,
    };

    return Promise.resolve(user);
  }),

  update: jest.fn().mockResolvedValue(createUserStub()),

  remove: jest.fn().mockResolvedValue(createUserStub()),
});
