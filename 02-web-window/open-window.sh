#!/usr/bin/env bash
# Opens the UI in its own app window (no tabs, no address bar), outside of Pharo.
URL=${1:-http://localhost:8765}
case "$(uname)" in
  Darwin) open -na "Google Chrome" --args --app="$URL" --window-size=520,360 --user-data-dir="${TMPDIR:-/tmp}/webhello-profile" ;;
  *)      (chrome --app="$URL" --window-size=520,360 || msedge --app="$URL" --window-size=520,360) ;;  # Windows: msedge ist vorinstalliert
esac
