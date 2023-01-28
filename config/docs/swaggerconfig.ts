import { DocumentBuilder } from '@nestjs/swagger';

export const swaggerConfig = new DocumentBuilder()
  .setTitle('Cardeal')
  .setDescription('API CardDeal')
  .setVersion('1.0')
  .addBearerAuth()
  .build();
