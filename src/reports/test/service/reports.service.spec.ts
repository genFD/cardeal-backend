import { Test, TestingModule } from '@nestjs/testing';
import { ReportsService } from '../../reports.service';
import { PrismaService } from '../../../prisma/prisma.service';
import { createReportStub } from '../stubs/reports.stub';
import { CreateReportDto } from '../../dto/create-report.dto';
import { createUserStub } from '../../../users/test/stubs/user.stub';
import { prismaMock } from '../../../prisma/__mocks__/singleton';
jest.mock('../../../prisma/prisma.service');
// import { createReport } from '../../../prisma/__mocks__/prisma.service';
describe('ReportsService unit tests', () => {
  let service: ReportsService;
  // let prisma: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ReportsService,
        PrismaService,
        {
          provide: PrismaService,
          useValue: prismaMock,
        },
      ],
    }).compile();

    service = module.get<ReportsService>(ReportsService);
    // prisma = module.get<PrismaService>(PrismaService);
  });

  describe('Reports service', () => {
    it('should be defined', () => {
      expect(service).toBeDefined();
    });
  });

  describe('create()', () => {
    it('should returns a new report', async () => {
      const report: CreateReportDto = {
        price: 1200,
        make: 'Hyundai',
        model: 'New Model',
        color: 'red',
        transmission: 'Automatic',
        fuel_type: 'Gasoline',
        year: 2020,
        mileage: 2394,
      };
      const user = createUserStub();

      const newReport = await service.create(report, user);
      console.log(newReport);

      // expect(newReport).toBeDefined();
    });
  });
});
