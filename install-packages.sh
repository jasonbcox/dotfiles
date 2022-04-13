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
NODE=""

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
  -n|--node)
    NODE=true
    shift  # shift past argument
    ;;
  *)
    echo "Unknown argument: $1"
    help_message
    exit 1
    ;;
esac
done

function join_by() {
  local IFS="$1"
  shift
  echo "$*"
}

# Always update existing packages first
sudo apt-get update
sudo apt-get upgrade

# Always install these base packages
BASE_PACKAGES=(
  apt-transport-https
  bash-completion
  git
  gpgconf
  software-properties-common
  tmux
  vim
)
sudo apt-get install $(join_by ' ' "${BASE_PACKAGES[@]}")

DEBUG_PACKAGES=(
  # For nslookup and dig
  dnsutils
  # Better resource monitor than top
  htop
  # For identify
  imagemagick
  # For ping
  iputils-ping
  # JSON formatter
  jq
  # For netstat
  net-tools
)
if [ "${DEBUG}" == "true" ]; then
  sudo apt-get install $(join_by ' ' "${DEBUG_PACKAGES[@]}")
fi

if [ "${NODE}" == "true" ]; then
  if [ ! -f ~/.profile_aliases ] || [ -z $(cat ~/.profile_aliases | grep N_PREFIX) ]; then
    (cat << EOF

export N_PREFIX="\${HOME}/.n"
export PATH="\${N_PREFIX}/bin":\${PATH}
EOF
    ) >> ~/.profile_aliases
  fi
  source ~/.profile_aliases

  # Install n (node manager)
  curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n-installer
  bash n-installer lts
  npm install --global n
  rm n-installer

  npm install --global yarn
fi
