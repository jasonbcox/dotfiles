#!/usr/bin/env bash

set -euxo pipefail

help_message() {
cat <<EOF
Install sets of packages. Useful for getting up and running quick.

Options:
-d, --debug           Install debugging tools.
-h, --help            Display this help message.
-n, --node            Install basic node JS tooling.
-p, --python          Install basic python tooling.
EOF
}

INSTALL_C=""
INSTALL_DEBUG=""
INSTALL_NODE=""
INSTALL_PYTHON=""

while [[ $# -gt 0 ]]; do
case $1 in
  -c|--cpp)
    INSTALL_C=true
    shift  # shift past argument
    ;;
  -d|--debug)
    INSTALL_DEBUG=true
    shift  # shift past argument
    ;;
  -h|--help)
    help_message
    exit 0
    ;;
  -n|--node)
    INSTALL_NODE=true
    shift  # shift past argument
    ;;
  -p|--python)
    INSTALL_PYTHON=true
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
sudo apt update
sudo apt -y upgrade

# Always install these base packages
BASE_PACKAGES=(
  apt-transport-https
  bash-completion
  curl
  git
  gpgconf
  software-properties-common
  tmux
  neovim
)
sudo apt -y install $(join_by ' ' "${BASE_PACKAGES[@]}")

C_PACKAGES=(
  ccache
  cmake
  gcc
  ninja-build
)
if [ "${INSTALL_C}" == "true" ]; then
  sudo apt -y install $(join_by ' ' "${C_PACKAGES[@]}")
fi

DEBUG_PACKAGES=(
  # For htpasswd
  apache2-utils
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
if [ "${INSTALL_DEBUG}" == "true" ]; then
  sudo apt -y install $(join_by ' ' "${DEBUG_PACKAGES[@]}")
fi

if [ "${INSTALL_NODE}" == "true" ]; then
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

PYTHON_PACKAGES=(
  python3
  python3-pip
  python3-venv
)
if [ "${INSTALL_PYTHON}" == "true" ]; then
  sudo apt -y install $(join_by ' ' "${PYTHON_PACKAGES[@]}")
fi
