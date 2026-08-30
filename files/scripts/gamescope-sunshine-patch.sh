#!/usr/bin/env bash
set -euo pipefail

session="/usr/share/gamescope-session-plus/sessions.d/steam"

python3 - "$session" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text()

old = '''function post_gamescope_start {
\t# Run steam-tweaks if exists
\tif command -v steam-tweaks > /dev/null; then
\t\tsteam-tweaks
\tfi
}'''

new = '''function post_gamescope_start {
    # Run steam-tweaks if exists
    if command -v steam-tweaks >/dev/null; then
        steam-tweaks
    fi

    # Sunshine belongs to the Gamescope session and inherits its environment.
    sunshine &
    SUNSHINE_PID=$!
}

function post_client_shutdown {
    if [[ -n "${SUNSHINE_PID:-}" ]] && kill -0 "$SUNSHINE_PID" 2>/dev/null; then
        kill "$SUNSHINE_PID"
        wait "$SUNSHINE_PID" 2>/dev/null || true
    fi
}'''

if old not in text:
    raise SystemExit(
        "ERROR: expected post_gamescope_start implementation not found; "
        "upstream gamescope session may have changed"
    )

path.write_text(text.replace(old, new, 1))
PY
