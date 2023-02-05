import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export const CurrentUser = createParamDecorator(
  (data: never, context: ExecutionContext) => {
    const request = context.switchToHttp().getRequest();
    return request.currentUser;
  },
);

// @Get('/whoami')
// whoAmI(@CurrentUser() currentUser: Users) {
//   return currentUser;
// }
