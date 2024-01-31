#!/usr/bin/env bash

set -euxo pipefail

TOPLEVEL=$(git rev-parse --show-toplevel)
cd "${TOPLEVEL}"

./setup.sh
./install-packages.sh -d -s

# Setup firewall
sudo ufw allow ssh
# Allow some UDP ports for mosh
sudo ufw allow 60000:60010/udp
# Start the firewall
sudo ufw enable
