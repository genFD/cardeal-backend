import { validationPipe } from '../config/validation/validationConfig';
// eslint-disable-next-line @typescript-eslint/no-var-requires
const cookieSession = require('cookie-session');

export const setupApp = (app: any) => {
  app.use(
    cookieSession({
      keys: ['efoeidsds'],
    }),
  );
  app.useGlobalPipes(validationPipe);
};
