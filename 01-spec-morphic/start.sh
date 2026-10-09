#!/usr/bin/env bash
# Starts a fresh Pharo with its GUI, loads src/ (Tonel) and opens the window.
# Requires: `stlive init` (downloads Pharo 13 into ~/.stlive). Windows: call Pharo.exe the same way (untested).
cd "$(dirname "$0")"; mkdir -p .gui
P=${STLIVE_HOME:-$HOME/.stlive}/pharo
cp -n "$P"/Pharo.image "$P"/Pharo.changes "$P"/*.sources .gui/
exec "$P"/pharo-vm/Pharo.app/Contents/MacOS/Pharo .gui/Pharo.image st "$PWD/run.st" --no-quit
