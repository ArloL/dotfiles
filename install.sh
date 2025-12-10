#!/bin/sh

set -o errexit
set -o nounset
set -o xtrace

OS="$(uname)"
if [ "${OS}" = "Linux" ]; then
  	platform=linux
elif [ "${OS}" = "Darwin" ]; then
  	platform=macos
fi

bash "$(dirname "$0")/install-${platform}.sh"
