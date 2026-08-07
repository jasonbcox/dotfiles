#!/usr/bin/env bash

function backup-home() {
  if [ "$#" -ne 1 ]; then
    echo "Expecting one argument: backup destination directory"
    return 1
  fi

  # TODO Remove dryrun after testing this some more
  rsync --dry-run -F -v -a ~ "$1"
}

function sort-images-and-video() {
  # Find all media with multiple date metadata (usually iPhone images). Conservatively move the ones where all of them match.
  find . -maxdepth 1 -type f -print0 | while IFS= read -r -d '' FILE; do
    YEAR=$(exiftool -d "%Y" -p '${DateTimeOriginal},${CreateDate},${ModifyDate}' "$FILE" | grep -E '^([0-9]{4}),\1,\1' | cut -d, -f1)
    if [ -n "$YEAR" ]; then
      mkdir -p "$YEAR"
      mv "$FILE" "$YEAR"/
    fi
  done

  # Use the less conservative CreationDate for .mov files
  find . -maxdepth 1 -type f -name '*.mov' -print0 | while IFS= read -r -d '' FILE; do
    YEAR=$(exiftool -d "%Y" -p '${CreationDate}' "$FILE")
    if [ -n "$YEAR" ]; then
      mkdir -p "$YEAR"
      mv "$FILE" "$YEAR"/
    fi
  done
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
    # Basic case. Download everything recursively from the URL (from any domain!).
    wget -rHpk -np -w3 --random-wait "$1"
  fi
  if [ "$#" -eq 2 ]; then
    # Filter by filetype
    wget -rH -np -w3 --random-wait -A"$2" "$1"
  fi
  if [ "$#" -eq 3 ]; then
    # Filter by filetype and domain. Example:
    # example.com has a list of links to downloads from amazonaws.com among
    # others. To filter only the amazonaws.com files, use that domain.
    wget -rH -np -w3 --random-wait -D"$3" -A"$2" "$1"
  fi
}

function archive-website() {
  ARGS="<domain>"
  if [ "$#" -lt 1 ]; then
    echo "Expecting at least one argument: ${ARGS}"
    return 1
  fi
  if [ "$#" -gt 1 ]; then
    echo "Expecting at most one argument: ${ARGS}"
    return 2
  fi

  # Download everything recursively from the domain, only matching that domain.
  DOMAIN="$1"
  wget -rHpkE -np -w3 --random-wait -D"${DOMAIN}" "${DOMAIN}"
}

function extract-from-mbox() {
  if [ "$#" -ne 2 ]; then
    echo "Expected arguments: <mbox> <email ID (GMail) or matching ^From address>"
    return 1
  fi
  MBOX="$1"
  FROM="$2"

  awk -v from="${FROM}" '
BEGIN { printing=0 }
/^From / {
  if (printing) exit;
  if (index($2, from) > 0) {
    printing=1;
  }
}
printing { print }
' "${MBOX}" | ripmime -i - -d .
}
