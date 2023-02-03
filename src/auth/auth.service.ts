import { BadRequestException, Injectable } from '@nestjs/common';
import { CreateAuthDto } from './dto/create-auth.dto';
import { UsersService } from '../users/users.service';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
  constructor(private usersService: UsersService) {}
  async signup(email: string, password: string) {
    //1- check if email is already in use
    const user = await this.usersService.findOneByEmail(email);
    if (user) throw new BadRequestException(`${email} is already taken `);

    //2-  Encrypt user's password
    const hashedAndSaltedPassword = await bcrypt.hash(password, 10);

    //3-  Store the new user's record
    const newUser = await this.usersService.create(
      email,
      hashedAndSaltedPassword,
    );

    //4- Send back a cookie that contains the user's id
    return newUser;
  }
  signin(createAuthDto: CreateAuthDto) {
    return 'This action adds a new auth';
  }
  signout(createAuthDto: CreateAuthDto) {
    return 'This action adds a new auth';
  }
}
