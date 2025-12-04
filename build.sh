#!/bin/bash

set -e

# Download Flutter (stable channel)
git clone https://github.com/flutter/flutter.git -b stable

# Add flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Enable web and verify SDK
flutter config --enable-web
flutter --version

# Build web
flutter build web
