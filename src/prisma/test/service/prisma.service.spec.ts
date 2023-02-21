import { Test, TestingModule } from '@nestjs/testing';
import { PrismaService } from '../../prisma.service';

describe('PrismaService unit tests', () => {
  let service: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PrismaService],
    }).compile();

    service = module.get<PrismaService>(PrismaService);
  });
  describe('PrismaService', () => {
    it('should be defined', () => {
      expect(service).toBeDefined();
    });
  });
});
