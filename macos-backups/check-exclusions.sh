#!/bin/sh

set -o errexit
set -o nounset
#set -o xtrace

while IFS= read -r line; do
  if [ "${line#"#"}" != "${line}" ]; then
    continue
  fi
  if [ -e "${line}" ]; then
    tmutil isexcluded "${line}"
  fi
done < "macos-ncdu-time-machine-exclude.txt"
