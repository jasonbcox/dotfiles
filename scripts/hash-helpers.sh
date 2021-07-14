#!/usr/bin/env bash

# Find all files in a tree and output a single hash of the entire output
function sha256sumdir() {
  if [ "$#" -ne 1 ]; then
    echo "Error: Expecting one argument (a directory)"
    return 1
  fi
  sha256sum <(find "$1" -printf "%s %f\\n")
}
