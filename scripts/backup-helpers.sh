#!/usr/bin/env bash

function backup-home() {
  if [ "$#" -ne 1 ]; then
    echo "Expecting one argument: backup destination directory"
    return 1
  fi

  # TODO Remove dryrun after testing this some more
  rsync --dry-run -F -v -a ~ "$1"
}

function archive-web-filetype() {
  ARGS="<url> [filetype] [domain]"
  if [ "$#" -lt 1 ]; then
    echo "Expecting at least one argument: ${ARGS}"
    return 1
  fi
  if [ "$#" -gt 3 ]; then
    echo "Expecting at most 3 arguments: ${ARGS}"
    return 2
  fi

  if [ "$#" -eq 1 ]; then
    # Basic case. Download everything recursively from the URL.
    wget -rH -w10 --random-wait "$1"
  fi
  if [ "$#" -eq 2 ]; then
    # Filter by filetype
    wget -rH -w10 --random-wait -A"$2" "$1"
  fi
  if [ "$#" -eq 3 ]; then
    # Filter by filetype and domain. Example:
    # example.com has a list of links to downloads from amazonaws.com among
    # others. To filter only the amazonaws.com files, use that domain.
    wget -rH -w10 --random-wait -D"$3" -A"$2" "$1"
  fi
}
