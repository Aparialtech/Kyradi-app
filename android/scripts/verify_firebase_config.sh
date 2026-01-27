#!/bin/sh
set -euo pipefail

if [ "${1:-}" != "release" ]; then
  echo "WARN: Firebase config check skipped for ${1:-unknown}."
  exit 0
fi

JSON_FILE="$(dirname "$0")/../app/google-services.json"
if [ ! -f "$JSON_FILE" ]; then
  echo "ERROR: google-services.json missing for Release build." 1>&2
  exit 1
fi

echo "OK: Firebase Android config present."
