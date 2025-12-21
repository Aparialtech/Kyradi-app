import { Test, TestingModule } from '@nestjs/testing';
import { LuggagesController } from './luggages.controller';

describe('LuggagesController', () => {
  let controller: LuggagesController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [LuggagesController],
    }).compile();

    controller = module.get<LuggagesController>(LuggagesController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
