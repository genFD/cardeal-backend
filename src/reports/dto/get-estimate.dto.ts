import { ApiProperty } from '@nestjs/swagger';
import { FUELTYPE, TRANSMISSION } from '@prisma/client';
import { Transform } from 'class-transformer';
import { IsNumber, IsString, Max, Min } from 'class-validator';

export class GetEstimateDto {
  @ApiProperty()
  @IsString()
  make: string;

  @ApiProperty()
  @IsString()
  model: string;

  @ApiProperty()
  @Transform(({ value }) => parseInt(value))
  @IsNumber()
  @Min(1930)
  @Max(2050)
  year: number;

  @ApiProperty()
  @IsString()
  color: string;

  @ApiProperty()
  @IsString()
  transmission: TRANSMISSION;

  @ApiProperty()
  @IsString()
  fuel_type: FUELTYPE;

  @ApiProperty()
  @Transform(({ value }) => parseInt(value))
  @IsNumber()
  @Min(0)
  @Max(1000000)
  mileage: number;
}
