#!/usr/bin/env bash

# Return metadata for images
alias image-metadata='exiftool'

function image-clear-metadata() {
  mogrify -strip "$@"
}

function whatismyip() {
  echo "$(curl -s ifconfig.me)"
}
