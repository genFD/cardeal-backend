import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { CreateUserDto } from '../users/dto/create-user.dto';
import { Auth } from './entities/auth.entity';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Users } from 'src/users/entities/user.entity';
import { Serialize } from 'src/interceptors/custom.interceptor';
import { UserDto } from '../users/dto/users.dto';

@Controller('auth')
@ApiTags('Auth')
@Serialize(UserDto)
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('/signup')
  @ApiOkResponse({ type: Users })
  signup(@Body() body: CreateUserDto) {
    return this.authService.signup(body.email, body.password);
  }
  @Post('/signin')
  @ApiOkResponse({ type: Users })
  signin(@Body() body: CreateUserDto) {
    return this.authService.signin(body.email, body.password);
  }
}
