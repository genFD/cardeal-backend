import { ApiProperty } from '@nestjs/swagger';
import { User } from '@prisma/client';

export class Users implements User {
  @ApiProperty()
  id: string;
  @ApiProperty()
  email: string;
  @ApiProperty()
  password: string;
}
