#!/usr/bin/env bash
# Einmalig: Pharo 14 (Image + passende VM) holen, Spec-Gtk laden, als base.image ablegen.
# Vorher: brew install gtk4 gtksourceview5
set -e; cd "$(dirname "$0")"; mkdir -p p14; cd p14
curl -s https://get.pharo.org/64/140 | bash
curl -s https://get.pharo.org/64/vm140 | bash
cat > load.st <<'ST'
Metacello new repository: 'github://pharo-spec/Spec-Gtk:main'; baseline: 'SpecGtk'; onConflict: [ :e | e useIncoming ]; onUpgrade: [ :e | e useIncoming ]; ignoreImage; load.
Smalltalk snapshot: true andQuit: true.
ST
./pharo-vm/Pharo.app/Contents/MacOS/Pharo --headless Pharo.image st load.st --save --quit
cp Pharo.image base.image; cp Pharo.changes base.changes
echo "fertig. Start: ../start.sh"
