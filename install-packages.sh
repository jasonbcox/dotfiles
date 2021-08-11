#!/usr/bin/env bash

set -euxo pipefail

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install git gpgconf htop vim tmux bash-completion dnsutils software-properties-common
