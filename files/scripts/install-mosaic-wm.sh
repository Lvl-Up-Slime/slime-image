#!/usr/bin/env bash
set -euo pipefail

git clone https://github.com/CleoMenezesJr/MosaicWM.git /tmp/MosaicWM
cd /tmp/MosaicWM

# Flip DEBUG off before building, per project's own recommendation
sed -i 's/const DEBUG = true;/const DEBUG = false;/' extension/logger.js

./scripts/build.sh -i

rm -rf /tmp/MosaicWM
