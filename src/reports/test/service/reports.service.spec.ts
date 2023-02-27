import { Test, TestingModule } from '@nestjs/testing';
import { ReportsService } from '../../reports.service';
import { PrismaService } from '../../../prisma/prisma.service';

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
});
