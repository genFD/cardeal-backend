import { Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { PrismaService } from 'prisma/prisma.service';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}
  create(body: CreateUserDto) {
    return this.prisma.user.create({ data: body });
  }

  findAll() {
    return this.prisma.user.findMany();
  }

  async findOne(id: string) {
    return await this.prisma.user.findUnique({ where: { id } });
  }

  update(id: string, attrs: UpdateUserDto) {
    return this.prisma.user.update({
      where: { id },
      data: attrs,
    });
  }

  remove(id: string) {
    return this.prisma.user.delete({ where: { id } });
  }
}
