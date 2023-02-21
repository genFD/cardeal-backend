import { Test } from '@nestjs/testing';
import { AuthService } from '../../auth.service';
import { BadRequestException, NotFoundException } from '@nestjs/common';
import { createUserStub } from '../../../users/test/stubs/user.stub';

import { UsersService } from '../../../users/users.service';

jest.mock('../../../users/users.service');

describe('AuthService', () => {
  let authService: AuthService;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      imports: [],
      providers: [AuthService, UsersService],
    }).compile();
    authService = module.get<AuthService>(AuthService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('can create an instance of the Auth Service', async () => {
    expect(authService).toBeDefined();
  });

  it('creates a new user with a salted and hashed password', async () => {
    const user = await authService.signup('user1@rmail.com', 'password');
    expect(user.password).not.toEqual('password');
    const { password } = user;

    expect(password).toBeDefined();
  });

  it('throws an error if user signs up with email that is in use', async () => {
    await expect(
      authService.signup(createUserStub().email, 'password'),
    ).rejects.toThrow(BadRequestException);
  });

  it('throws an error if user signs in with email that is not in use', async () => {
    await expect(
      authService.signin('user2@email.com', 'password'),
    ).rejects.toThrow(NotFoundException);
  });

  it('throws an error if user signs in with incorrect password', async () => {
    await expect(
      authService.signin(createUserStub().email, 'passworrrrd'),
    ).rejects.toThrow(BadRequestException);
  });

  it('returns a user if correct password is provided', async () => {
    const user = await authService.signin(createUserStub().email, 'password');
    expect(user).toBeDefined();
  });
});
