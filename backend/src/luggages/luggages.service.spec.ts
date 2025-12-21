import { Test, TestingModule } from '@nestjs/testing';
import { LuggagesService } from './luggages.service';

describe('LuggagesService', () => {
  let service: LuggagesService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [LuggagesService],
    }).compile();

    service = module.get<LuggagesService>(LuggagesService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
