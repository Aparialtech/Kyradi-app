#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

URI="${NEW_MONGODB_URI:-${MONGODB_URI:-}}"
if [[ -z "$URI" ]]; then
  echo "ERROR: NEW_MONGODB_URI or MONGODB_URI is not set."
  exit 1
fi

docker run --rm \
  mongo:6 \
  mongosh "$URI" --quiet --eval '
const cols = [
  "users",
  "locations",
  "luggages",
  "profile_verification_codes",
  "password_reset_tokens",
  "user_verification_codes"
];
cols.forEach(c => {
  try {
    const count = db.getCollection(c).countDocuments();
    print(`${c}: ${count}`);
  } catch (e) {
    print(`${c}: ERROR ${e}`);
  }
});
'

