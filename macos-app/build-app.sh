#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_NAME="Orbit Music.app"
BUILD_DIR="$SCRIPT_DIR/build"
APP_BUNDLE="$BUILD_DIR/$APP_NAME"

if ! command -v swiftc >/dev/null 2>&1; then
  echo "Swift compiler not found. Install Xcode or the Xcode Command Line Tools first." >&2
  exit 1
fi

rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"

swiftc -parse-as-library -O \
  -framework SwiftUI \
  -framework AppKit \
  -framework Foundation \
  -o "$APP_BUNDLE/Contents/MacOS/OrbitMusic" \
  "$SCRIPT_DIR/Sources/OrbitMusicApp.swift"

cat > "$APP_BUNDLE/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>OrbitMusic</string>
    <key>CFBundleIdentifier</key>
    <string>com.hightechmit.orbitmusic</string>
    <key>CFBundleName</key>
    <string>Orbit Music</string>
    <key>CFBundleDisplayName</key>
    <string>Orbit Music</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
</dict>
</plist>
PLIST

chmod +x "$APP_BUNDLE/Contents/MacOS/OrbitMusic"
echo "Built: $APP_BUNDLE"
echo "This app is unsigned. If macOS blocks it, Control-click the app in Finder and choose Open."
open "$APP_BUNDLE"
