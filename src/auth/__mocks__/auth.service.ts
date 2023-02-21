import { createUserStub } from '../../users/test/stubs/user.stub';

export const AuthService = jest.fn().mockReturnValue({
  signup: jest.fn((email: string, password: string) => {
    const user = {
      id: Math.floor(Math.random() * 99).toString(),
      email: email,
      password: password,
      admin: false,
    };

    return Promise.resolve(user);
  }),

  signin: jest.fn((email: string, password: string) => {
    if (
      email === createUserStub().email &&
      password === createUserStub().password
    )
      return Promise.resolve(createUserStub());
  }),
});
