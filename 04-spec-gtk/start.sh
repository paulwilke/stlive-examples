#!/usr/bin/env bash
# Voraussetzung: brew install gtk4 ; Pharo-14-Image mit Spec-Gtk in p14/ (siehe NOTES.md)
cd "$(dirname "$0")/p14"
cp -f base.image Pharo.image; cp -f base.changes Pharo.changes   # frisches Image, nie das gespeicherte benutzen
exec ./pharo-vm/Pharo.app/Contents/MacOS/Pharo --worker --headless Pharo.image st ../run.st
