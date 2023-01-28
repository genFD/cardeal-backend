import { User } from '@prisma/client';
import { ApiProperty } from '@nestjs/swagger';

export class Users implements User {
  @ApiProperty()
  admin: boolean;

  @ApiProperty()
  id: string;

  @ApiProperty()
  email: string;

  @ApiProperty()
  password: string;
}
