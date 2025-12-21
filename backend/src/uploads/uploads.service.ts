import { Injectable } from '@nestjs/common';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class UploadsService {
  private readonly uploadDir = path.join(process.cwd(), 'uploads', 'identity');

  constructor() {
    fs.mkdirSync(this.uploadDir, { recursive: true });
  }

  buildFileUrl(filename: string) {
    return `/uploads/identity/${filename}`;
  }

  getDestination() {
    return this.uploadDir;
  }
}
