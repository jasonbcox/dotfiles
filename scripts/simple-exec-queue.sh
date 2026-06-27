#!/bin/bash

set -euo pipefail

# A simple single-reader, multi-writer queue that executes the specified command plus any other arguments in the queue.
# Each line in the queue triggers one execution of the command.

if [ "$#" -lt 1 ]; then
  echo "Expecting arguments: <command> [args...]"
  exit 1
fi

CMD=("$@")

QUEUES_DIR=/tmp/jason
mkdir -p "${QUEUES_DIR}"
LATEST_QUEUE="${QUEUES_DIR}"/exec-queue.latest
rm -f "${LATEST_QUEUE}"

QUEUE=$(mktemp -p "${QUEUES_DIR}" exec-queue.XXXXX)
ln -s "${QUEUE}" "${LATEST_QUEUE}"
OFFSET="${QUEUE}.offset"
touch "${OFFSET}"
chmod 600 "${QUEUE}" "${OFFSET}"

# Warning: cleanup may run twice. If INT signal fires, cleanup is called and then EXIT fires triggering it again.
# Ensure cleanup stays idempotent.
cleanup() { rm -f "${QUEUE}" "${OFFSET}"; }
trap cleanup EXIT INT TERM HUP

# Detect spaces within quoted strings
RE_DOUBLE_QUOTE='"[^"]* [^"]*"'
RE_SINGLE_QUOTE="'[^']* [^']*'"

echo "Queue ready for writing: ${QUEUE}" >&2
echo "Symlink to most recent queue: ${LATEST_QUEUE}" >&2

while IFS= read -r LINE; do
  NEXT=$(( $(cat "${OFFSET}") + 1 ))
  if [[ "${LINE}" =~ ${RE_DOUBLE_QUOTE} ]] || [[ "${LINE}" =~ ${RE_SINGLE_QUOTE} ]]; then
      echo "WARNING: Spaces inside quotes will be split incorrectly: ${LINE}" >&2
      echo "Skipping this line:" >&2
      echo "    ${LINE}" >&2
  else
    # Execute
    read -ra EXTRA_ARGS <<< "${LINE}"
    if ! "${CMD[@]}" "${EXTRA_ARGS[@]}"; then
      # Note: If this script needs to support retries in the future, just let `set -e` exit the script on error.
      # The offset is not advanced yet, so this script could support retries if we want.
      echo "Warning: Command failed for this line:" >&2
      echo "    ${LINE}" >&2
    fi
  fi

  echo "${NEXT}" > "${OFFSET}"
done < <(tail --pid=$$ -n +1 -F "${QUEUE}")
