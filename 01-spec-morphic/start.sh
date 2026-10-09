#!/usr/bin/env bash
# Startet ein frisches Pharo mit GUI, laedt src/ (Tonel) und oeffnet das Fenster.
# Voraussetzung: `stlive init` (laedt Pharo 13 nach ~/.stlive). Windows: Pharo.exe analog aufrufen.
cd "$(dirname "$0")"; mkdir -p .gui
P=${STLIVE_HOME:-$HOME/.stlive}/pharo
cp -n "$P"/Pharo.image "$P"/Pharo.changes "$P"/*.sources .gui/
exec "$P"/pharo-vm/Pharo.app/Contents/MacOS/Pharo .gui/Pharo.image st "$PWD/run.st" --no-quit
