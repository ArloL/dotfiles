#!/bin/sh

set -o errexit
set -o nounset
set -o xtrace

ncdu --exclude-from ~/.dotfiles/macos-backups/macos-ncdu-time-machine-exclude.txt /
