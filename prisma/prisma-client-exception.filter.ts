import { ArgumentsHost, Catch, HttpStatus } from '@nestjs/common';
import { BaseExceptionFilter } from '@nestjs/core';
import { Prisma } from '@prisma/client';
import { Response } from 'express';

@Catch(Prisma.PrismaClientKnownRequestError)
export class PrismaClientExceptionFilter extends BaseExceptionFilter {
  catch(exception: Prisma.PrismaClientKnownRequestError, host: ArgumentsHost) {
    const context = host.switchToHttp();
    const response = context.getResponse<Response>();

    switch (exception.code) {
      case 'P2002':
        const status = HttpStatus.CONFLICT;
        const message = exception.message.replace(/\n/g, '');
        response.status(HttpStatus.CONFLICT).json({
          status,
          message,
        });

        break;
      default:
        super.catch(exception, host);
    }
  }
}
