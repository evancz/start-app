#!/bin/bash

set -e
set -v

if [ "$1" == "--clean" ]; then
  rm -Rf elm-stuff/build-artifacts
fi

if [ ! -d node_modules/jsdom ]; then
  npm install jsdom@3
fi

mkdir -p target
elm-make src/Test/TestMain.elm --output target/test.js
./elm-io.sh target/test.js target/test.io.js
node target/test.io.js
