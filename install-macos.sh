#!/usr/bin/env bash
############################
# Install the dotfiles on macOS systems.
############################

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
    local dotfiles=("bashrc" "bash_profile" "config" "default-gems" "zshenv" "puppet-lint.rc" "mavenrc" "gradle" "zprofile")

    # setup symlinks in homedir
    createSymlinks "${scriptPath}" "${HOME}" "${backupDir}" 1 dotfiles[@]
}

setupBin() {
    local scriptPath
    scriptPath=$( cd "$( dirname "$0" )" && pwd )

    # backup directory
    local backupDir="${HOME}/dotfiles_backup/bin"

    # list of files/folders to symlink in homedir
    local binfiles=("update-everything" "base64-encode-stdin.sh" "yarn-link")

    mkdir -p "${HOME}/bin"
    chflags hidden "${HOME}/bin"

    # setup symlinks in homedir/bin
    createSymlinks "${scriptPath}/bin" "${HOME}/bin" "${backupDir}" 0 binfiles[@]
}

setupVSCode() {
    local scriptPath
    scriptPath=$( cd "$( dirname "$0" )" && pwd )

    local vsCodeDir="${HOME}/Library/Application Support/Code"

    # backup directory
    local backupDir="${vsCodeDir}/dotfiles_backup"

    # the folders to symlink for visual studio code
    local vsCodeFolders=("User")

    if [ -d "/Applications/Visual Studio Code.app" ]; then
        mkdir -p "${vsCodeDir}"
        # setup symlinks for visual studio code
        createSymlinks "${scriptPath}/vscode" "${vsCodeDir}" "${backupDir}" 0 vsCodeFolders[@]
    fi
}

setupSdkman() {
    local scriptPath
    scriptPath=$( cd "$( dirname "$0" )" && pwd )

    local sdkmanDir="${HOME}/.sdkman"

    # backup directory
    local backupDir="${HOME}/dotfiles_backup/sdkman"

    # the folders to symlink
    local sdkmanFolders=("etc")

    if [ -d "${sdkmanDir}" ]; then
        # setup symlinks for sdkman
        createSymlinks "${scriptPath}/sdkman" "${sdkmanDir}" "${backupDir}" 0 sdkmanFolders[@]
    fi
}

setupHome
setupBin
setupVSCode
setupSdkman
