import { Controller, Post, UploadedFile, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { randomUUID } from 'crypto';
import { UploadsService } from './uploads.service';
import * as path from 'path';

type UploadedIdentityFile = {
  filename: string;
};

@Controller('uploads')
export class UploadsController {
  constructor(private readonly uploadsService: UploadsService) {}

  @Post('identity')
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: (_req, _file, cb) => cb(null, path.join(process.cwd(), 'uploads', 'identity')),
        filename: (_req, file, cb) => {
          const ext = path.extname(file.originalname);
          cb(null, `${randomUUID()}${ext}`);
        },
      }),
      limits: { fileSize: 5 * 1024 * 1024 },
    }),
  )
  uploadIdentity(@UploadedFile() file: UploadedIdentityFile) {
    if (!file) {
      return { message: 'No file uploaded' };
    }
    return {
      fileUrl: this.uploadsService.buildFileUrl(file.filename),
      filename: file.filename,
    };
  }
}
