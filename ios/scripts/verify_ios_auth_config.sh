#!/bin/sh
set -euo pipefail

if [ "${CONFIGURATION:-}" != "Release" ]; then
  exit 0
fi

APP_DIR="${PROJECT_DIR}/Runner"
INFO_PLIST="${APP_DIR}/Info.plist"
ENTITLEMENTS="${APP_DIR}/Runner.entitlements"

SCHEMES_RAW="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleURLTypes' "$INFO_PLIST" 2>/dev/null || true)"
if [ -z "$SCHEMES_RAW" ]; then
  echo "ERROR: CFBundleURLTypes missing in Info.plist." 1>&2
  exit 1
fi

SCHEME_MATCHED=0
SCHEME_COUNT="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleURLTypes' "$INFO_PLIST" 2>/dev/null | grep -c 'Dict' || true)"
INDEX=0
while [ "$INDEX" -lt "$SCHEME_COUNT" ]; do
  SCHEME_VALUE="$(/usr/libexec/PlistBuddy -c "Print :CFBundleURLTypes:${INDEX}:CFBundleURLSchemes:0" "$INFO_PLIST" 2>/dev/null || true)"
  if echo "$SCHEME_VALUE" | grep -q '^com.googleusercontent.apps\.'; then
    SCHEME_MATCHED=1
    break
  fi
  INDEX=$((INDEX + 1))
done

if [ "$SCHEME_MATCHED" -ne 1 ]; then
  echo "ERROR: Google URL scheme missing in Info.plist (expected com.googleusercontent.apps.*)." 1>&2
  exit 1
fi

APPLE_SIGNIN="$(/usr/libexec/PlistBuddy -c 'Print :com.apple.developer.applesignin:0' "$ENTITLEMENTS" 2>/dev/null || true)"
if [ "$APPLE_SIGNIN" != "Default" ]; then
  echo "ERROR: Apple Sign-In entitlement missing (com.apple.developer.applesignin = Default)." 1>&2
  exit 1
fi

echo "OK: iOS auth config validated for Release."
