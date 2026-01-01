#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

set -a
source .env.local
set +a

./tools/replace_web_key.sh
flutter run -d chrome
