import {
  Controller,
  Get,
  Post,
  Body,
  Session,
  UseInterceptors,
  UseGuards,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { CreateUserDto } from '../users/dto/create-user.dto';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Users } from 'src/users/entities/user.entity';
import { Serialize } from 'src/interceptors/custom.interceptor';
import { UserDto } from '../users/dto/users.dto';
import { UsersService } from '../users/users.service';
import { CurrentUser } from './decorators/current.user.decorator';
import { AuthGuard } from './guards/auth.guard';

@Controller('auth')
@ApiTags('Auth')
@Serialize(UserDto)
export class AuthController {
  constructor(
    private readonly authService: AuthService, // private readonly usersService: UsersService,
  ) {}

  @Post('/signup')
  @ApiOkResponse({ type: Users })
  async signup(@Body() body: CreateUserDto, @Session() session: any) {
    const user = await this.authService.signup(body.email, body.password);
    session.userId = user.id;
    return user;
  }
  @Post('/signin')
  @ApiOkResponse({ type: Users })
  async signin(@Body() body: CreateUserDto, @Session() session: any) {
    const user = await this.authService.signin(body.email, body.password);
    session.userId = user.id;
    return user;
  }

  // @Get('/whoami')
  // whoAmI(@Session() session: any) {
  //   return this.usersService.findOneById(session.userId);
  // }

  @Post('/signout')
  async logout(@Session() session: any) {
    session.userId = null;
  }
  @UseGuards(AuthGuard)
  @Get('/whoami')
  whoAmI(@CurrentUser() currentUser: Users) {
    console.log(currentUser);
    return currentUser;
  }
}
