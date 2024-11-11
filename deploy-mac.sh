#!/bin/zsh

rm -rf /Applications/rikiki.app

flutter build macos

cp -r ./build/macos/Build/Products/Release/rikiki_multiplatform.app /Applications/rikiki.app
