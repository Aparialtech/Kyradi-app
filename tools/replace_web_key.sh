#!/usr/bin/env bash
set -euo pipefail

FILE="web/index.html"
PLACEHOLDER="__WEB_MAPS_KEY__"

if [[ -z "${WEB_MAPS_KEY:-}" ]]; then
  echo "WEB_MAPS_KEY env var bos. Ornek: export WEB_MAPS_KEY=AIzaSy..."
  exit 1
fi

# macOS sed
sed -i '' "s/${PLACEHOLDER}/${WEB_MAPS_KEY}/g" "$FILE"
echo "Replaced ${PLACEHOLDER} in ${FILE}"
