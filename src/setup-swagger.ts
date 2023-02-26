import { SwaggerModule } from '@nestjs/swagger';
import { swaggerConfig } from '../config/docs/swaggerconfig';

export const setupSwagger = (app: any) => {
  const document = SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup('api', app, document);
};
