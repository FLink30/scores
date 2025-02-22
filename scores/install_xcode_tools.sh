#!/bin/bash

echo "Installing Xcode Command Line Tools..."
apt-get update
apt-get install -y --no-install-recommends \
    xz-utils \
    curl
mkdir -p /XcodeCommandLineTools
cd /XcodeCommandLineTools
curl -fsSL -O https://developer.apple.com/download/more/?=command%20line%20tools
tar -xvf ./*.dmg
hdiutil attach ./*.dmg
installer -pkg /Volumes/*.*/Install*.pkg -target /
hdiutil detach /Volumes/*.*/
rm -rf ./*.dmg

