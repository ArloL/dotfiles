#!/bin/sh
DIRECTORIES="${HOME}/.dotfiles/vscode/User/workspaceStorage/*"
for DIRECTORY in $DIRECTORIES
do
    if [ -d "${DIRECTORY}" ]; then
        WORKSPACE_FOLDER=$(jq -r '.folder' "${DIRECTORY}/workspace.json")
        if [ "${WORKSPACE_FOLDER}" = "null" ] || [ ! -d "${WORKSPACE_FOLDER#file://}" ]; then
            echo "${WORKSPACE_FOLDER#file://}"
            rm -rf "${DIRECTORY}"
        fi
    fi
done
