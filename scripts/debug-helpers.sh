#!/usr/bin/env bash

# Return metadata for images
function image-metadata() {
  if [ "$#" -ne 1 ]; then
    echo "Error: Expecting one argument: <image file>"
    return 1
  fi
  identify -verbose "$1"
  echo "Summary:"
  identify "$1"
}

function whatismyip() {
  echo "$(curl -s ifconfig.me)"
}
