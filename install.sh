#!/usr/bin/env bash
############################
# Create symlinks from the home directory to any desired dotfiles directory.
############################

function fail()
{
  echo "${1}"
  exit 1
}

function createSymlinks()
{
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

    if [ ${withDot} -eq 1 ]; then
      local fullpath="${targetDirectory}/.${symlink}"
    else
      local fullpath="${targetDirectory}/${symlink}"
    fi

    # continue if already a symlink
    if [ -h "${fullpath}" ]; then
      echo "Skipping ${symlink}, symlink already exists"
      continue;
    fi

    # move any existing files/dirs to $backupdir
    if [ -a "${fullpath}" ]; then

      # create backupdir if it does not exist
      if [ ! -d "${backupdir}" ]; then
        mkdir -p "${backupdir}"
      fi

      echo "Moving existing ${symlink} to ${backupdir}"
      mv "${fullpath}" "${backupdir}/${symlink}"
    fi

    echo "Creating symlink ${fullpath}."
  done
  # unset otherwise symlink contains last iteration value
  unset symlink
}

function setupHome()
{
  local scriptPath=$( cd "$( dirname "$0" )" && pwd )

  # backup directory
  local backupDir="${HOME}/dotfiles_backup"

  # list of files/folders to symlink in homedir
  local dotfiles=("bashrc" "bash_profile" "bash" "dir_colors" "inputrc" "minttyrc" "gitconfig")

  # setup symlinks in homedir
  createSymlinks "${scriptPath}" "${HOME}" "${backupDir}" 1 dotfiles[@]
}

function setupSublime()
{
  local scriptPath=$( cd "$( dirname "$0" )" && pwd )

  # the folders to symlink for Sublime
  local sublimeFolders=("Installed Packages" "Packages" "Pristine Packages")

  local sublimeDir="${HOME}/Library/Application Support/Sublime Text 2"

  # backup directory
  local backupDir="${HOME}/Library/Application Support/Sublime Text 2/Backup"

  if [ -d "${sublimeDir}" ]; then
    # setup symlinks for sublime
    createSymlinks "${scriptPath}/sublime" "${sublimeDir}" "${backupDir}" 0 sublimeFolders[@]
  fi
}

setupHome
setupSublime
