import { Injectable } from '@nestjs/common';
import * as fs from 'fs';
import * as path from 'path';
import * as crypto from 'crypto';

@Injectable()
export class UploadsService {
  private readonly baseUploadDir =
    process.env.UPLOADS_DIR ?? path.join(process.cwd(), 'uploads');
  private readonly uploadDir = path.join(this.baseUploadDir, 'identity');

  constructor() {
    fs.mkdirSync(this.uploadDir, { recursive: true });
  }

  buildFileUrl(filename: string) {
    return `/uploads/identity/${filename}`;
  }

  buildIdentityUrl(relativePath: string) {
    const normalized = relativePath.replace(/^\/+/, '');
    return `/uploads/identity/${normalized}`;
  }

  getIdentityPath(filename: string) {
    return path.join(this.uploadDir, filename);
  }

  getBaseDir() {
    return this.baseUploadDir;
  }

  async sha256(filePath: string): Promise<string> {
    const hash = crypto.createHash('sha256');
    const stream = fs.createReadStream(filePath);
    return await new Promise((resolve, reject) => {
      stream.on('data', (chunk) => hash.update(chunk));
      stream.on('error', reject);
      stream.on('end', () => resolve(hash.digest('hex')));
    });
  }

  async readMagic(filePath: string, bytes = 16): Promise<Buffer> {
    const fd = await fs.promises.open(filePath, 'r');
    try {
      const buf = Buffer.alloc(bytes);
      await fd.read(buf, 0, bytes, 0);
      return buf;
    } finally {
      await fd.close();
    }
  }

  isMagicValid(mime: string, magic: Buffer): boolean {
    const m = (mime ?? '').toLowerCase();
    const isJpeg = magic[0] === 0xff && magic[1] === 0xd8;
    const isPng =
      magic[0] === 0x89 &&
      magic[1] === 0x50 &&
      magic[2] === 0x4e &&
      magic[3] === 0x47;
    const isWebp =
      magic.subarray(0, 4).toString('ascii') === 'RIFF' &&
      magic.subarray(8, 12).toString('ascii') === 'WEBP';
    const ascii = magic.toString('ascii');
    const isHeic =
      ascii.includes('ftypheic') ||
      ascii.includes('ftypheif') ||
      ascii.includes('ftypmif1');

    const isAnyImage = isJpeg || isPng || isWebp || isHeic;

    if (!m || m === 'application/octet-stream' || m === 'binary/octet-stream') {
      return isAnyImage;
    }
    if (m === 'image/jpeg' || m === 'image/jpg') return isJpeg;
    if (m === 'image/png') return isPng;
    if (m === 'image/webp') return isWebp;
    if (m === 'image/heic' || m === 'image/heif') return isHeic;
    if (m.startsWith('image/')) return isAnyImage;
    return false;
  }

  getDestination() {
    return this.uploadDir;
  }
}
