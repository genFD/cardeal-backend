import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  NotFoundException,
  Query,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Users } from './entities/user.entity';
import { Serialize } from 'src/interceptors/custom.interceptor';
import { UserDto } from './dto/users.dto';

@Serialize(UserDto)
@Controller('users')
@ApiTags('Users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  create(@Body() body: CreateUserDto) {
    return this.usersService.create(body.email, body.password);
  }

  @Get()
  @ApiOkResponse({ type: [Users] })
  findAll() {
    return this.usersService.findAll();
  }

  @Get(':id')
  @ApiOkResponse({ type: Users })
  async findOne(@Param('id') id: string) {
    const user = await this.usersService.findOneById(id);
    if (!user) throw new NotFoundException(`User ${id} not found`);
    return user;
  }
  @Get('/email/first')
  @ApiOkResponse({ type: Users })
  async findOneByEmail(@Query('email') email: string) {
    const user = await this.usersService.findOneByEmail(email);
    if (!user) throw new NotFoundException(`User ${email} not found`);
    return user;
  }

  @Patch(':id')
  @ApiOkResponse({ type: Users })
  update(@Param('id') id: string, @Body() data: UpdateUserDto) {
    return this.usersService.update(id, data);
  }

  @Delete(':id')
  @ApiOkResponse({ type: Users })
  remove(@Param('id') id: string) {
    return this.usersService.remove(id);
  }
}
