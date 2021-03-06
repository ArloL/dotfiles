#!/usr/bin/env bash

set -o errexit
set -o nounset

fail() {
    echo "${1}"
    exit 1
}

createSymlinks() {
    local sourceDirectory=${1}
    local targetDirectory=${2}
    local backupDirectory=${3}
    local withDot=${4}
    declare -a symlinks=("${!5}")

    if [ ! -d "${sourceDirectory}" ]; then
        fail "Directory ${sourceDirectory} does not exist."
    fi

    if [ ! -d "${targetDirectory}" ]; then
        fail "Directory ${targetDirectory} does not exist."
    fi

    for symlink in "${symlinks[@]}"; do

        if [ "${withDot}" -eq "1" ]; then
            local fullLinkTarget="${targetDirectory}/.${symlink}"
        else
            local fullLinkTarget="${targetDirectory}/${symlink}"
        fi

        # continue if already a symlink
        if [ -h "${fullLinkTarget}" ]; then
            echo "Skipping ${symlink}, symlink already exists"
            continue;
        fi

        # move any existing files/dirs to $backupDirectory
        if [ -a "${fullLinkTarget}" ]; then

            echo "${backupDirectory}"
            # create backupDirectory if it does not exist
            if [ ! -d "${backupDirectory}" ]; then
                mkdir -p "${backupDirectory}"
            fi

            echo "Moving existing ${symlink} to ${backupDirectory}"
                mv "${fullLinkTarget}" "${backupDirectory}/${symlink}"
        fi

        echo "Creating symlink ${fullLinkTarget}."
        ln -s "${sourceDirectory}/${symlink}" "${fullLinkTarget}"

    done

    # unset otherwise symlink contains last iteration value
    unset symlink
}

setupHome() {
    local scriptPath
    scriptPath=$( cd "$( dirname "$0" )" && pwd )

    # backup directory
    local backupDir="${HOME}/dotfiles_backup"

    # list of files/folders to symlink in homedir
    local dotfiles=("bashrc" "bash_profile" "config" "zshenv")

    # setup symlinks in homedir
    createSymlinks "${scriptPath}" "${HOME}" "${backupDir}" 1 dotfiles[@]
}

setupHome
