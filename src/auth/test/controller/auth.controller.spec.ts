import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from '../../auth.controller';
import { AuthService } from '../../auth.service';
import { UsersService } from '../../../users/users.service';
import { createUserStub } from '../../../users/__mocks__/users.service';
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
});
