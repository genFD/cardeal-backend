import { Users } from '../entities/user.entity';
export const createUserStub = (): Users => {
  return {
    id: 'userstubId',
    email: 'userStub@email.com',
    password: 'password',
    admin: false,
  };
};
export const UsersService = jest.fn().mockReturnValue({
  findAll: jest.fn().mockResolvedValue([createUserStub()]),

  findOneById: jest.fn((id: string) => {
    if (id === createUserStub().id) return Promise.resolve(createUserStub());
  }),

  findOneByEmail: jest.fn((email: string) => {
    if (email === createUserStub().email)
      return Promise.resolve(createUserStub());
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
