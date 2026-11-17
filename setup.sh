#!/bin/sh
# phbot setup: extract phbot.phext from the stored phbot.phext.xz.
# The repo stores the artifact compressed (11,000,268 bytes); the phext
# itself is 91,495,468 bytes, SHA-256
# 41c7ad5b821b8389eff2492378d162659aac9fd8c117d0243d9680316655f966.
set -e
cd "$(dirname "$0")"
EXPECTED=41c7ad5b821b8389eff2492378d162659aac9fd8c117d0243d9680316655f966
if [ -f phbot.phext ] && [ "$(sha256sum phbot.phext | cut -d' ' -f1)" = "$EXPECTED" ]; then
  echo "phbot.phext already extracted and verified."
  exit 0
fi
command -v xz >/dev/null 2>&1 || { echo "setup: xz is required (xz-utils)" >&2; exit 1; }
xz -dkf phbot.phext.xz
ACTUAL=$(sha256sum phbot.phext | cut -d' ' -f1)
if [ "$ACTUAL" != "$EXPECTED" ]; then
  echo "setup: SHA-256 mismatch: got $ACTUAL" >&2
  exit 1
fi
echo "phbot.phext extracted and verified (91,495,468 bytes)."
