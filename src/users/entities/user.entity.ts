import { ApiProperty } from '@nestjs/swagger';
import { User } from '@prisma/client';

export class Users implements User {
  admin: boolean;
  // admin: boolean;
  @ApiProperty()
  id: string;
  @ApiProperty()
  email: string;
  @ApiProperty()
  password: string;
}
