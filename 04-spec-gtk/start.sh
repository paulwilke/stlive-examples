#!/usr/bin/env bash
# Requires: brew install gtk4 gtksourceview5, and ./setup.sh run once (Pharo 14 image with Spec-Gtk in p14/)
cd "$(dirname "$0")/p14"
cp -f base.image Pharo.image; cp -f base.changes Pharo.changes   # always start from a fresh copy, never reuse a saved image
exec ./pharo-vm/Pharo.app/Contents/MacOS/Pharo --worker --headless Pharo.image st ../run.st
