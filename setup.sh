#!/usr/bin/env bash

set -euo pipefail

mv .bashrc .bashrc.old || true
mv .bash_profile .bash_profile.old || true

ln -s .sourcemybashrc .bashrc
ln -s .sourcemybashrc .bash_profile
source .bashrc.custom

mkdir -p ~/projects
