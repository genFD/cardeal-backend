import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateReportDto } from './dto/create-report.dto';
import { UpdateReportDto } from './dto/update-report.dto';
import { PrismaService } from '../prisma/prisma.service';
import { Users } from '../users/entities/user.entity';
import { GetEstimateDto } from './dto/get-estimate.dto';

@Injectable()
export class ReportsService {
  constructor(private prisma: PrismaService) {}

  async create(report: CreateReportDto, user: Users) {
    return await this.prisma.report.create({
      data: {
        ...report,
        author: {
          connect: { id: user.id },
        },
      },
    });
  }

  async approveReport(id: string, approved: boolean) {
    const report = await this.prisma.report.update({
      where: {
        id,
      },
      data: { approved },
    });
    if (!report) {
      throw new NotFoundException(`Report with ${id} not found`);
    }

    return report;
  }

  async createEstimate(estimate: GetEstimateDto) {
    return this.prisma.report.aggregate({
      _avg: {
        price: true,
      },
      where: {
        approved: true,
        make: {
          equals: estimate.make,
          mode: 'insensitive',
        },
        model: {
          equals: estimate.model,
          mode: 'insensitive',
        },
      },
      orderBy: {
        mileage: 'desc',
      },
      take: 3,
    });
  }

  findAll() {
    return this.prisma.report.findMany();
  }

  async findOne(id: string) {
    const report = await this.prisma.report.findUnique({
      where: {
        id,
      },
    });
    if (!id) return null;
    if (!report)
      throw new NotFoundException(`Cannot find report with id ${id}`);
    return report;
  }

  async findOneByMake(make: string) {
    const report = await this.prisma.report.findMany({
      where: {
        make,
      },
    });
    return report;
  }

  update(id: string, data: UpdateReportDto) {
    return this.prisma.report.update({
      where: { id },
      data,
    });
  }

  remove(id: string) {
    return this.prisma.report.delete({ where: { id } });
  }
}
