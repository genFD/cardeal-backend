import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from '../../auth.service';
import { UsersService } from '../../../users/users.service';

import { createUserStub } from '../../../users/test/stubs/user.stub';

describe('AuthService', () => {
  let authService: AuthService;

  // let usersService;
  const mockUsersService = {
    findOneByEmail: () => Promise.resolve({}),
  };
  beforeEach(async () => {
    const module = await Test.createTestingModule({
      imports: [],

      providers: [AuthService, UsersService],
    })
      .overrideProvider(UsersService)
      .useValue(mockUsersService)
      .compile();
    authService = module.get(AuthService);
  });

  it('can create an instance of the Auth Service', async () => {
    expect(authService).toBeDefined();
  });
});
