#!/usr/bin/env bash

set -euxo pipefail

TOPLEVEL=$(git rev-parse --show-toplevel)
cd "${TOPLEVEL}"

# TODO: Copy .templates/.profile_aliases once it has been refactored to work on multiple platforms
touch .profile_aliases

# Only attempt to install packages if user has sudo privileges
if sudo -nv 2>&1 | grep -v "may not run sudo" > /dev/null; then
  ./install-packages.sh
fi

# Assume that .gnupg/gpg-agent.conf may have changed, so restart gpg-agent
# (kill it, it will restart as needed)
gpgconf --kill gpg-agent

mv .bashrc .bashrc.old || true
mv .bash_profile .bash_profile.old || true

ln -s .sourcemybashrc .bashrc
ln -s .sourcemybashrc .bash_profile

mkdir -p projects

if [ ! -f .gituser ]; then
  cp .templates/.gituser .
  echo "Defaulting to this .gituser:"
  cat .gituser
fi

if [ ! -f launch-tmux.sh ]; then
  cp .templates/launch-tmux.sh .
fi
