#!/bin/sh
set -euo pipefail

if [ "${CONFIGURATION:-}" != "Release" ]; then
  exit 0
fi

APP_DIR="${PROJECT_DIR}/Runner"
INFO_PLIST="${APP_DIR}/Info.plist"

API_KEY="$(/usr/libexec/PlistBuddy -c 'Print :GOOGLE_MAPS_API_KEY' "$INFO_PLIST" 2>/dev/null || true)"
if [ -z "$API_KEY" ]; then
  echo "ERROR: GOOGLE_MAPS_API_KEY missing in Info.plist (Release requires Maps key)." 1>&2
  exit 1
fi

echo "OK: iOS Maps config validated for Release."
