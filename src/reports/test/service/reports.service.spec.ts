import { Test, TestingModule } from '@nestjs/testing';
import { ReportsService } from '../../reports.service';
import { PrismaService } from '../../../prisma/prisma.service';
import { createUserStub } from '../../../users/test/stubs/user.stub';

jest.mock('../../../prisma/prisma.service');

describe('ReportsService unit tests', () => {
  let service: ReportsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [ReportsService, PrismaService],
    }).compile();

    service = module.get<ReportsService>(ReportsService);
  });

  describe('Reports service', () => {
    it('should be defined', () => {
      expect(service).toBeDefined();
    });
  });

  describe('create()', () => {
    it('should returns a new report', async () => {
      const user = {
        id: 'uuid',
        email: 'userStub@email.com',
        password: 'password',
        admin: false,
      };
      const report = {
        price: 1200,
        make: 'Hyundai',
        model: 'New Model',
        color: 'red',
        transmission: 'Automatic',
        fuel_type: 'Gasoline',
        year: 2020,
        mileage: 2394,
        approved: false,
      };

      const nr = await service.create(report, user);

      expect(nr).toBeDefined();
    });
  });
});
