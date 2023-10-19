#!/bin/bash

TEMP_CRON_FILE=/etc/cron.d/temp-get-cron-env
cleanup() {
  sudo rm "${TEMP_CRON_FILE}"
}
trap cleanup EXIT

echo "* * * * * ${USER} /usr/bin/env > ${HOME}/.run-as-cron-env" | sudo tee "${TEMP_CRON_FILE}"

echo "Fetching cron env (1 minute)"
for I in {1..6} ; do
  printf "."
  sleep 10
done
echo "Done!"
