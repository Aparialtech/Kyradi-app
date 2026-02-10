import {
  BadRequestException,
  Controller,
  Post,
  Req,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { randomUUID } from 'crypto';
import { UploadsService } from './uploads.service';
import * as path from 'path';
import * as fs from 'fs';
import { IdentityVerificationService } from '../users/identity-verification.service';

type UploadedIdentityFile = {
  filename: string;
  mimetype?: string;
  size?: number;
  originalname?: string;
};

const ALLOWED_MIME = new Set([
  'image/jpeg',
  'image/png',
  'image/webp',
  'image/heic',
  'image/heif',
]);

type IdentityDocType = 'id_front' | 'id_back' | 'selfie';

@Controller('uploads')
export class UploadsController {
  constructor(
    private readonly uploadsService: UploadsService,
    private readonly identityService: IdentityVerificationService,
  ) {}

  @Post('identity')
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: (_req, _file, cb) =>
          cb(null, path.join(process.env.UPLOADS_DIR ?? path.join(process.cwd(), 'uploads'), 'identity')),
        filename: (_req, file, cb) => {
          const ext = path.extname(file.originalname);
          cb(null, `${randomUUID()}${ext}`);
        },
      }),
      fileFilter: (_req, file, cb) => {
        if (!ALLOWED_MIME.has(file.mimetype)) {
          return cb(new Error('INVALID_FILE_TYPE'), false);
        }
        return cb(null, true);
      },
      limits: {
        fileSize:
          Math.max(
            Number(process.env.UPLOAD_MAX_MB ?? 5),
            Number(process.env.KYC_MAX_UPLOAD_MB ?? 5),
            1,
          ) * 1024 * 1024,
      },
    }),
  )
  async uploadIdentity(@Req() req: any, @UploadedFile() file: UploadedIdentityFile) {
    if (!file) {
      return { message: 'No file uploaded' };
    }

    const typeRaw = (req.query?.type ?? '').toString().trim();
    const type = typeRaw as IdentityDocType;

    // Backward-compatible: if no type is provided, keep old behavior.
    if (!typeRaw) {
      return {
        fileUrl: this.uploadsService.buildFileUrl(file.filename),
        filename: file.filename,
      };
    }

    if (type !== 'id_front' && type !== 'id_back' && type !== 'selfie') {
      throw new BadRequestException('KYC_DOC_TYPE_INVALID');
    }

    const userId = req.user?.id?.toString() ?? '';
    if (!userId) {
      throw new BadRequestException('UNAUTHORIZED');
    }

    // Enforce KYC flag only for typed uploads.
    if (!this.identityService.isEnabled()) {
      throw new BadRequestException('KYC_DISABLED');
    }

    const tmpPath = this.uploadsService.getIdentityPath(file.filename);
    const exists = fs.existsSync(tmpPath);
    if (!exists) {
      throw new BadRequestException('UPLOAD_MISSING_FILE');
    }

    const magic = await this.uploadsService.readMagic(tmpPath);
    const mime = (file.mimetype ?? '').toString();
    if (!this.uploadsService.isMagicValid(mime, magic)) {
      try {
        fs.unlinkSync(tmpPath);
      } catch {
        // ignore
      }
      throw new BadRequestException('INVALID_FILE_TYPE');
    }

    const sha256 = await this.uploadsService.sha256(tmpPath);
    const stats = fs.statSync(tmpPath);
    const record = await this.identityService.ensureDraft(userId);

    const ext = path.extname(file.filename) || '.jpg';
    const finalDir = path.join(
      process.cwd(),
      'uploads',
      'identity',
      userId,
      record._id.toString(),
    );
    fs.mkdirSync(finalDir, { recursive: true });
    const finalName = `${type}-${Date.now()}${ext}`;
    const finalPath = path.join(finalDir, finalName);
    fs.renameSync(tmpPath, finalPath);

    const relative = path.posix.join(userId, record._id.toString(), finalName);
    const url = this.uploadsService.buildIdentityUrl(relative);

    await this.identityService.attachDocument({
      userId,
      type,
      url,
      mime,
      size: stats.size,
      sha256,
    });

    return {
      fileUrl: url,
      url,
      type,
      sha256,
      filename: finalName,
      verificationId: record._id.toString(),
    };
  }
}
