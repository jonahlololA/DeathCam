#!/usr/bin/env sh
set -eu
GRADLE_VERSION=9.5.0
BOOT_DIR="${HOME}/.gradle/deathcam-bootstrap"
GRADLE_EXE="${BOOT_DIR}/gradle-${GRADLE_VERSION}/bin/gradle"
if [ ! -x "$GRADLE_EXE" ]; then
  mkdir -p "$BOOT_DIR"
  ZIP="${BOOT_DIR}/gradle-${GRADLE_VERSION}-bin.zip"
  echo "Gradle ${GRADLE_VERSION} is not installed. Downloading it now..."
  if command -v curl >/dev/null 2>&1; then
    curl -fL "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o "$ZIP"
  else
    wget "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -O "$ZIP"
  fi
  unzip -oq "$ZIP" -d "$BOOT_DIR"
fi
exec "$GRADLE_EXE" "$@"
