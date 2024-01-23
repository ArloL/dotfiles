#!/bin/sh

set -o errexit
set -o nounset
set -o xtrace

cd "$(dirname "$0")" || exit 1

ncdu \
    --exclude-from ./macos-ncdu-time-machine-exclude.txt \
    /
