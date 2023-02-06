import { Injectable } from '@nestjs/common';
import { CreateReportDto } from './dto/create-report.dto';
import { UpdateReportDto } from './dto/update-report.dto';
import { PrismaService } from '../prisma/prisma.service';
import { Users } from '../users/entities/user.entity';

@Injectable()
export class ReportsService {
  constructor(private prisma: PrismaService) {}

  async create(report: CreateReportDto, user: Users) {
    console.log('created');
    const newReport = await this.prisma.report.create({
      data: {
        ...report,
        author: {
          connect: { id: user.id },
        },
      },
    });
    return newReport;
  }

  remove(id: number) {
    return `This action removes a #${id} report`;
  }
}
