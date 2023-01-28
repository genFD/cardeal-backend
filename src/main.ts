import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { swaggerConfig } from 'config/docs/swaggerconfig';
import { SwaggerModule } from '@nestjs/swagger';
import { validationPipe } from '../config/validation/validationConfig';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(validationPipe);
  const document = SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup('api', app, document);
  await app.listen(process.env.PORT || 8000);
}
bootstrap();
