import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from '../users/users.module';
import { CurrentUserInterceptor } from './interceptor/current.user.interceptor';

@Module({
  imports: [UsersModule],
  controllers: [AuthController],
  providers: [AuthService, CurrentUserInterceptor],
})
export class AuthModule {}
