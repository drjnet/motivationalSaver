#!/usr/bin/env bash
# build.sh — local build script for MotivationalScreensaver
#
# Usage:
#   ./build.sh              # build for current arch (fast, for testing)
#   ./build.sh --universal  # build universal binary (arm64 + x86_64)
#   ./build.sh --install    # build + install to ~/Library/Screen Savers/
#   ./build.sh --universal --install

set -euo pipefail

SCHEME="MotivationalScreensaver"
PROJECT="MotivationalScreensaver.xcodeproj"
BUNDLE_NAME="MotivationalScreensaver.saver"
ZIP_NAME="MotivationalScreensaver.zip"
BUILD_DIR="$(mktemp -d)/build"
ENTITLEMENTS="Resources/MotivationalScreensaver.entitlements"

UNIVERSAL=false
INSTALL=false

for arg in "$@"; do
  case $arg in
    --universal) UNIVERSAL=true ;;
    --install)   INSTALL=true  ;;
  esac
done

echo "==> Building $SCHEME ($( $UNIVERSAL && echo 'universal' || echo 'current arch' ))"

if $UNIVERSAL; then
  ARCH_FLAGS="ONLY_ACTIVE_ARCH=NO ARCHS=\"arm64 x86_64\""
else
  ARCH_FLAGS="ONLY_ACTIVE_ARCH=YES"
fi

xcodebuild \
  -project "$PROJECT" \
  -scheme  "$SCHEME" \
  -configuration Release \
  -derivedDataPath "$BUILD_DIR" \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  $ARCH_FLAGS \
  build

SAVER=$(find "$BUILD_DIR" -name "$BUNDLE_NAME" -type d | head -1)
if [ -z "$SAVER" ]; then
  echo "ERROR: $BUNDLE_NAME not found in $BUILD_DIR" >&2
  exit 1
fi

echo "==> Signing ad-hoc with entitlements"
codesign --force --sign - --entitlements "$ENTITLEMENTS" "$SAVER"

echo "==> Removing quarantine attribute"
xattr -cr "$SAVER"

if $INSTALL; then
  DEST="$HOME/Library/Screen Savers/$BUNDLE_NAME"
  echo "==> Installing to $DEST"
  rm -rf "$DEST"
  cp -R "$SAVER" "$DEST"
  echo "==> Done! Open System Settings → Screen Saver to activate."
else
  cp -R "$SAVER" .
  cp INSTALL.md .
  echo "==> Zipping"
  rm -f "$ZIP_NAME"
  zip -r "$ZIP_NAME" "$BUNDLE_NAME" INSTALL.md
  echo "==> Created $ZIP_NAME"
  echo "    Share this file with friends — they just double-click the .saver inside."
fi
