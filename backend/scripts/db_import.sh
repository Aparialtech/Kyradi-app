#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

URI="${NEW_MONGODB_URI:-${MONGODB_URI:-}}"
if [[ -z "$URI" ]]; then
  echo "ERROR: NEW_MONGODB_URI or MONGODB_URI is not set."
  exit 1
fi

if [[ ! -f "$ROOT_DIR/backups/old_dump.archive" ]]; then
  echo "ERROR: backups/old_dump.archive not found. Run db_export.sh first."
  exit 1
fi

docker run --rm \
  -v "$ROOT_DIR/backups:/backup" \
  mongo:6 \
  mongorestore --uri="$URI" --archive=/backup/old_dump.archive --gzip --drop

echo "Import complete into: $URI"
