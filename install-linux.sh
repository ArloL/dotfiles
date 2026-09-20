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

        # "source:name" links source under a different name, "name" uses it as is
        local linkSource="${symlink%%:*}"
        local linkName="${symlink##*:}"

        if [ "${withDot}" -eq "1" ]; then
            local fullLinkTarget="${targetDirectory}/.${linkName}"
        else
            local fullLinkTarget="${targetDirectory}/${linkName}"
        fi

        # continue if already a symlink
        if [ -h "${fullLinkTarget}" ]; then
            echo "Skipping ${linkName}, symlink already exists"
            continue;
        fi

        # move any existing files/dirs to $backupDirectory
        if [ -a "${fullLinkTarget}" ]; then

            echo "${backupDirectory}"
            # create backupDirectory if it does not exist
            if [ ! -d "${backupDirectory}" ]; then
                mkdir -p "${backupDirectory}"
            fi

            echo "Moving existing ${linkName} to ${backupDirectory}"
                mv "${fullLinkTarget}" "${backupDirectory}/${linkName}"
        fi

        echo "Creating symlink ${fullLinkTarget}."
        ln -s "${sourceDirectory}/${linkSource}" "${fullLinkTarget}"

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

setupBin() {
    local scriptPath
    scriptPath=$( cd "$( dirname "$0" )" && pwd )

    # backup directory
    local backupDir="${HOME}/dotfiles_backup/bin"

    # list of files/folders to symlink in homedir
    local binfiles=("update-everything" "base64-encode-stdin.sh" "yarn-link"  "git-push-main")

    mkdir -p "${HOME}/bin"

    # setup symlinks in homedir/bin
    createSymlinks "${scriptPath}/bin" "${HOME}/bin" "${backupDir}" 0 binfiles[@]
}

setupClaude() {
    local scriptPath
    scriptPath=$( cd "$( dirname "$0" )" && pwd )

    local claudeDir="${HOME}/.claude"

    # backup directory
    local backupDir="${HOME}/dotfiles_backup/claude"

    # the files to symlink
    local claudeFiles=("settings.json" "AGENTS.md:CLAUDE.md")

    mkdir -p "${claudeDir}"

    # setup symlinks for claude
    createSymlinks "${scriptPath}/claude" "${claudeDir}" "${backupDir}" 0 claudeFiles[@]
}

setupHome
setupBin
setupClaude
