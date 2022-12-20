#!/usr/bin/env bash
############################
# Install the dotfiles on OS X systems.
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
    local dotfiles=("bashrc" "bash_profile" "config" "zshenv" "puppet-lint.rc" "mavenrc")

    # setup symlinks in homedir
    createSymlinks "${scriptPath}" "${HOME}" "${backupDir}" 1 dotfiles[@]
}

setupBin() {
    local scriptPath
    scriptPath=$( cd "$( dirname "$0" )" && pwd )

    # backup directory
    local backupDir="${HOME}/dotfiles_backup/bin"

    # list of files/folders to symlink in homedir
    local binfiles=("update-everything" "base64-encode-stdin.sh")

    mkdir -p "${HOME}/bin"

    # setup symlinks in homedir/bin
    createSymlinks "${scriptPath}/bin" "${HOME}/bin" "${backupDir}" 0 binfiles[@]
}

setupSublime() {
    local scriptPath
    scriptPath=$( cd "$( dirname "$0" )" && pwd )

    local sublimeDir="${HOME}/Library/Application Support/Sublime Text 3/Packages"

    # backup directory
    local backupDir="${sublimeDir}/dotfiles_backup"

    # the folders to symlink for Sublime
    local sublimeFolders=("User" "User (OS Settings)")

    if [ -d "${sublimeDir}" ]; then
        # setup symlinks for sublime
        createSymlinks "${scriptPath}/sublime" "${sublimeDir}" "${backupDir}" 0 sublimeFolders[@]
    fi
}

setupAtom() {
    local scriptPath
    scriptPath=$( cd "$( dirname "$0" )" && pwd )

    local atomDir="${HOME}/.atom"

    # backup directory
    local backupDir="${HOME}/dotfiles_backup"

    # list of files/folders to symlink in homedir/.atom
    local atomFiles=("config.cson" "init.coffee" "keymap.cson" "snippets.cson" "styles.less")

    if [ -d "${atomDir}" ]; then
        # setup symlinks for atom
        createSymlinks "${scriptPath}/atom" "${atomDir}" "${backupDir}" 0 atomFiles[@]
    fi
}

setupVSCode() {
    local scriptPath
    scriptPath=$( cd "$( dirname "$0" )" && pwd )

    local vsCodeDir="${HOME}/Library/Application Support/Code"

    # backup directory
    local backupDir="${vsCodeDir}/dotfiles_backup"

    # the folders to symlink for visual studio code
    local vsCodeFolders=("User")

    if [ -d "${vsCodeDir}" ]; then
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
        # setup symlinks for visual studio code
        createSymlinks "${scriptPath}/sdkman" "${sdkmanDir}" "${backupDir}" 0 sdkmanFolders[@]
    fi
}

setupHome
setupBin
setupSublime
setupAtom
setupVSCode
setupSdkman
