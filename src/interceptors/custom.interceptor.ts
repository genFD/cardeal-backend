import {
  UseInterceptors,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

// GOAl
//@Serialize(DTO)
//@UseInterceptor(new customInterceptor(DTO))

export class CustomInterceptor implements NestInterceptor {
  constructor(private dto: ClassConstructor) {}
  // 1
  intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Observable<any> | Promise<Observable<any>> {
    // 2
    return next.handle().pipe(
      // 3
      map((data) => {
        return plainToInstance(this.dto, data, {
          excludeExtraneousValues: true,
        });
      }),
    );
  }
}

interface ClassConstructor {
  new (...args: any[]): object;
}
// 3
export function Serialize(dto: ClassConstructor) {
  return UseInterceptors(new CustomInterceptor(dto));
}
