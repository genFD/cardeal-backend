import { Injectable, NotFoundException } from '@nestjs/common';
import { UpdateUserDto } from './dto/update-user.dto';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}
  create(email: string, password: string) {
    return this.prisma.user.create({ data: { email, password } });
  }

  findAll() {
    return this.prisma.user.findMany();
  }

  async findOneById(id: string) {
    const user = await this.prisma.user.findUnique({
      where: {
        id,
      },
    });
    if (!id) return null;
    if (!user) throw new NotFoundException(`Cannot find user with id ${id}`);
    return user;
  }

  async findOneByEmail(email: string) {
    const user = await this.prisma.user.findUnique({
      where: {
        email: email,
      },
    });
    // if (!email) return null;
    // if (!user)
    //   throw new NotFoundException(`Cannot find user with email ${email}`);
    return user;
  }

  update(id: string, data: UpdateUserDto) {
    return this.prisma.user.update({
      where: { id },
      data,
    });
  }

  remove(id: string) {
    return this.prisma.user.delete({
      where: { id },
    });
  }
}
