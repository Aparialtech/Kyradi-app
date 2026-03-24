import { Test, TestingModule } from '@nestjs/testing';
import { AppController } from './app.controller';

describe('AppController', () => {
  let appController: AppController;

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      controllers: [AppController],
    }).compile();

    appController = app.get<AppController>(AppController);
  });

  describe('__version', () => {
    it('should return version payload', () => {
      const payload = appController.version();
      expect(payload).toHaveProperty('builtAt');
      expect(payload).toHaveProperty('commit');
    });
  });
});
