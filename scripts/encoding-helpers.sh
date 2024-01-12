#!/usr/bin/env bash

# Return metadata for images
function decode-html() {
  SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

  if [ "$#" -ne 1 ]; then
    echo "Error: Expecting one argument: <HTML escaped string>"
    return 1
  fi

  echo "$1" | "${SCRIPT_DIR}"/decode-html.py
}
