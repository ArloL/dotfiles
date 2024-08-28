#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o xtrace

sudo sysctl debug.lowpri_throttle_enabled=0

pgrep_result=$(pgrep -f "backupd")

if [ -z "$pgrep_result" ]; then
    echo "No processes found."
else
    while IFS= read -r pid; do
        sudo renice "-20" -p "${pid}"
    done <<< "$pgrep_result"
fi
