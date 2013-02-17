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
  shift
  local targetDirectory=${1}
  shift
  local backupDirectory=${1}
  shift
  local symlinks=(${@})

  if [ ! -d "${sourceDirectory}" ]; then
    fail "Directory ${sourceDirectory} does not exist."
  fi

  if [ ! -d "${targetDirectory}" ]; then
    fail "Directory ${targetDirectory} does not exist."
  fi

  for symlink in "${symlinks[@]}"; do

    local fullpath="${targetDirectory}/.${symlink}"

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

scriptpath=$( cd "$( dirname "$0" )" && pwd )

# backup directory
backupDir="${HOME}/dotfiles_backup"

# list of files/folders to symlink in homedir
dotfiles=("bashrc" "bash_profile" "bash" "dir_colors" "inputrc" "minttyrc" "gitconfig")

createSymlinks "${scriptpath}/sublime" "${HOME}" "${backupDir}" "${dotfiles[@]}"
