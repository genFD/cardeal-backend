import { ApiProperty } from '@nestjs/swagger';
import { FUELTYPE, Report, TRANSMISSION } from '@prisma/client';

export class Reports implements Report {
  approved: boolean;
  // @ApiProperty()
  // approved: boolean;
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
  transmission: TRANSMISSION;
  @ApiProperty()
  fuel_type: FUELTYPE;
  @ApiProperty()
  year: number;
  @ApiProperty()
  mileage: number;
}
