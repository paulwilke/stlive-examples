#!/usr/bin/env bash
# Oeffnet die UI als eigenes App-Fenster (ohne Tabs/Adressleiste) - ausserhalb von Pharo.
URL=${1:-http://localhost:8765}
case "$(uname)" in
  Darwin) open -na "Google Chrome" --args --app="$URL" --window-size=520,360 --user-data-dir="${TMPDIR:-/tmp}/webhello-profile" ;;
  *)      (chrome --app="$URL" --window-size=520,360 || msedge --app="$URL" --window-size=520,360) ;;  # Windows: msedge ist vorinstalliert
esac
