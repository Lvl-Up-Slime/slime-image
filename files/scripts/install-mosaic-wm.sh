#!/usr/bin/env bash
set -euo pipefail

UUID="mosaicwm@cleomenezesjr.github.io"

git clone https://github.com/CleoMenezesJr/MosaicWM.git /tmp/MosaicWM
cd /tmp/MosaicWM

grep -q 'const DEBUG = true;' extension/logger.js
sed -i 's/const DEBUG = true;/const DEBUG = false;/' extension/logger.js

./scripts/build.sh -b

mkdir -p "/usr/share/gnome-shell/extensions/$UUID"
unzip -o "$UUID.zip" -d "/usr/share/gnome-shell/extensions/$UUID"

if [ -d "/usr/share/gnome-shell/extensions/$UUID/schemas" ]; then
    glib-compile-schemas "/usr/share/gnome-shell/extensions/$UUID/schemas"
fi

cd /
rm -rf /tmp/MosaicWM
