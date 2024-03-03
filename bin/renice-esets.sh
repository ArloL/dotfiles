#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o xtrace

processes=("com.eset.devices" "com.eset.endpoint" "com.eset.firewall" "com.eset.network" "esets_ctl" "esets_daemon" "esets_fcor" "esets_fwhelper" "esets_mac" "esets_proxy")

for process in "${processes[@]}"; do

    pgrep_result=$(pgrep -f "${process}")

    if [ -z "$pgrep_result" ]; then
        echo "No processes found."
    else
        while IFS= read -r pid; do
            sudo renice 20 -p "${pid}"
        done <<< "$pgrep_result"
    fi

done
