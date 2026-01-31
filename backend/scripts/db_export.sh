#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ -z "${OLD_MONGODB_URI:-}" ]]; then
  echo "ERROR: OLD_MONGODB_URI is not set."
  exit 1
fi

mkdir -p backups

docker run --rm \
  -v "$ROOT_DIR/backups:/backup" \
  mongo:6 \
  mongodump --uri="$OLD_MONGODB_URI" --archive=/backup/old_dump.archive --gzip

echo "Export complete: backups/old_dump.archive"
