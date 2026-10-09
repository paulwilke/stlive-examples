#!/usr/bin/env bash
# Builds HelloShell.app: Rust shell + Pharo VM + prepared image (WebHello built in). The end user installs nothing.
set -e; cd "$(dirname "$0")"
P=${STLIVE_HOME:-$HOME/.stlive}/pharo
cargo build --release
APP=dist/HelloShell.app; rm -rf dist; R=$APP/Contents/Resources/pharo
mkdir -p $APP/Contents/MacOS $R
cp target/release/hello-shell $APP/Contents/MacOS/
cp -R $P/pharo-vm $R/
# Prepare the image: load the code, save the snapshot
mkdir -p .prep && cp $P/Pharo.image $P/Pharo.changes $P/*.sources .prep/
cat > .prep/prepare.st <<'ST'
Metacello new baseline: 'WebHello'; repository: 'tonel://', (FileLocator workingDirectory parent parent / '02-web-window' / 'src') fullName; load.
Smalltalk snapshot: true andQuit: true.
ST
(cd .prep && $P/pharo-vm/Pharo.app/Contents/MacOS/Pharo --headless Pharo.image st prepare.st --save --quit)
cp .prep/Pharo.image $R/app.image; cp .prep/Pharo.changes $R/app.changes; cp .prep/*.sources $R/
echo "(Smalltalk at: #WebHello) start: 8765." > $R/start.st
cat > $APP/Contents/Info.plist <<'PL'
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict><key>CFBundleName</key><string>HelloShell</string><key>CFBundleIdentifier</key><string>de.demo.helloshell</string>
<key>CFBundleExecutable</key><string>hello-shell</string><key>CFBundlePackageType</key><string>APPL</string><key>CFBundleVersion</key><string>1</string>
<key>NSHighResolutionCapable</key><true/><key>LSMinimumSystemVersion</key><string>12.0</string></dict></plist>
PL
echo "fertig: $APP ($(du -sh $APP | cut -f1))"
