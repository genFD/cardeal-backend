import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Query,
} from '@nestjs/common';
import { ReportsService } from './reports.service';
import { CreateReportDto } from './dto/create-report.dto';
import { UpdateReportDto } from './dto/update-report.dto';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/decorators/current.user.decorator';
import { Users } from '../users/entities/user.entity';
import { AuthGuard } from '../auth/guards/auth.guard';
import { ApproveReportDTO } from './dto/approve.reports.dto';
import { AdminGuard } from '../auth/guards/admin.guard';
import { GetEstimateDto } from './dto/get-estimate.dto';
import { Reports } from './entities/report.entity';

@Controller('reports')
@ApiTags('Reports')
export class ReportsController {
  constructor(private readonly reportsService: ReportsService) {}

  @Post()
  @ApiOkResponse({ type: Reports })
  @UseGuards(AuthGuard)
  create(@Body() report: CreateReportDto, @CurrentUser() user: Users) {
    return this.reportsService.create(report, user);
  }
  @Patch('/approve/:id')
  @ApiOkResponse({ type: Reports })
  @UseGuards(AdminGuard)
  approveReport(@Param('id') id: string, @Body() body: ApproveReportDTO) {
    return this.reportsService.approveReport(id, body.approved);
  }

  @Get('/estimate')
  @ApiOkResponse({ type: Reports })
  getEstimate(@Query() query: GetEstimateDto) {
    return this.reportsService.createEstimate(query);
  }

  @Get()
  @ApiOkResponse({ type: [Reports] })
  findAll() {
    return this.reportsService.findAll();
  }

  @Get(':id')
  @ApiOkResponse({ type: Reports })
  findOne(@Param('id') id: string) {
    return this.reportsService.findOne(id);
  }
  @Get('/make/first')
  @ApiOkResponse({ type: Reports })
  async findOneByMake(@Query('make') make: string) {
    const report = await this.reportsService.findOneByMake(make);
    if (!report) return null;
    return report;
  }
  // @Patch(':id')
  // @UseGuards(AdminGuard)
  // @ApiOkResponse({ type: Reports })
  // update(@Param('id') id: string, @Body() data: UpdateReportDto) {
  //   return this.reportsService.update(id, data);
  // }
  @Delete(':id')
  @ApiOkResponse({ type: Reports })
  remove(@Param('id') id: string) {
    return this.reportsService.remove(id);
  }
}
