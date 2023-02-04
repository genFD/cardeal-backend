import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { swaggerConfig } from 'config/docs/swaggerconfig';
import { SwaggerModule } from '@nestjs/swagger';
import { validationPipe } from '../config/validation/validationConfig';
// import cookieSession from 'cookie-session';
// eslint-disable-next-line @typescript-eslint/no-var-requires
const cookieSession = require('cookie-session');

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.use(
    cookieSession({
      keys: ['efoeidsds'],
    }),
  );
  app.useGlobalPipes(validationPipe);
  const document = SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup('api', app, document);
  await app.listen(process.env.PORT || 8000);
}
bootstrap();
