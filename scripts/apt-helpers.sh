#!/usr/bin/env bash

alias apthelper-depends="apt-cache depends -i"
alias apthelper-list-upgradeable="apt list --upgradeable | cut -d/ -f1 | grep -v nvidia | grep -v cuda | grep -v \"^lib\""
alias apthelper-upgrade-existing="sudo apt install --only-upgrade"
