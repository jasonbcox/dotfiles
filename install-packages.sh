#!/usr/bin/env bash

set -euxo pipefail

help_message() {
cat <<EOF
Install sets of packages. Useful for getting up and running quick.

Options:
-d, --debug           Install debugging tools.
-h, --help            Display this help message.
EOF
}

DEBUG=""

while [[ $# -gt 0 ]]; do
case $1 in
  -d|--debug)
    DEBUG=true
    shift  # shift past argument
    ;;
  -h|--help)
    help_message
    exit 0
    ;;
  *)
    echo "Unknown argument: $1"
    help_message
    exit 1
    ;;
esac
done

# Always update existing packages first
sudo apt-get update
sudo apt-get upgrade

# Always install these base packages
sudo apt-get install git gpgconf vim tmux bash-completion software-properties-common

if [ "${DEBUG}" == "true" ]; then
  sudo apt-get install htop dnsutils
fi
