import { ApiProperty } from '@nestjs/swagger';
import { Report } from '@prisma/client';

export class Reports implements Report {
  @ApiProperty()
  approved: boolean;
  @ApiProperty()
  authorId: string;
  @ApiProperty()
  id: string;
  @ApiProperty()
  price: number;
  @ApiProperty()
  make: string;
  @ApiProperty()
  model: string;
  @ApiProperty()
  color: string;
  @ApiProperty()
  transmission: string;
  @ApiProperty()
  fuel_type: string;
  @ApiProperty()
  year: number;
  @ApiProperty()
  mileage: number;
}
