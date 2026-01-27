#!/bin/sh
set -euo pipefail

if [ "${ACTION:-}" = "install" ]; then
  echo "Archive build detected — skipping Verify Dart Defines"
  exit 0
fi

if [ "${CONFIGURATION:-}" != "Release" ]; then
  exit 0
fi

if [ -z "${DART_DEFINES:-}" ]; then
  if [ -f "${PROJECT_DIR}/Flutter/flutter_export_environment.sh" ]; then
    # shellcheck disable=SC1091
    . "${PROJECT_DIR}/Flutter/flutter_export_environment.sh"
  fi
fi

if [ -z "${DART_DEFINES:-}" ]; then
  if [ -f "${PROJECT_DIR}/Flutter/Generated.xcconfig" ]; then
    DART_DEFINES="$(grep -E '^DART_DEFINES=' "${PROJECT_DIR}/Flutter/Generated.xcconfig" | sed 's/^DART_DEFINES=//')"
  fi
fi

if [ -z "${DART_DEFINES:-}" ]; then
  echo "ERROR: DART_DEFINES is empty in Release. Pass --dart-define=API_BASE_URL=..." 1>&2
  exit 1
fi

decode_base64() {
  echo "$1" | /usr/bin/base64 --decode 2>/dev/null || echo "$1" | /usr/bin/base64 -D
}

found=0
old_ifs=$IFS
IFS=,
set -- $DART_DEFINES
IFS=$old_ifs
for part in "$@"; do
  decoded="$(decode_base64 "$part")"
  case "$decoded" in
    API_BASE_URL=*)
      value="${decoded#API_BASE_URL=}"
      if [ -n "$value" ]; then
        found=1
      fi
      ;;
  esac
done

if [ "$found" -ne 1 ]; then
  echo "ERROR: API_BASE_URL missing in Release build. Build aborted." 1>&2
  exit 1
fi
