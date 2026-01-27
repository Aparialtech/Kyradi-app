#!/bin/sh
set -euo pipefail

if [ "${CONFIGURATION:-}" != "Release" ]; then
  echo "WARN: Firebase config check skipped for ${CONFIGURATION:-unknown}."
  exit 0
fi

PLIST="${PROJECT_DIR}/Runner/GoogleService-Info.plist"
if [ ! -f "$PLIST" ]; then
  echo "ERROR: GoogleService-Info.plist missing for Release build." 1>&2
  exit 1
fi

echo "OK: Firebase iOS config present."
