#!/usr/bin/env bash

# Find all files in a tree and output a single hash of the entire output
function sha256sumdir() {
  if [ "$#" -ne 1 ]; then
    echo "Error: Expecting one argument (a directory)"
    return 1
  fi
  pushd "$1" > /dev/null
  sha256sum <(find . -printf "%s %f\\n")
  popd > /dev/null
}
