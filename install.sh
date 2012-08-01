#!/usr/bin/env bash
############################
# Create symlinks from the home directory to any desired dotfiles directory.
############################

# dotfiles directory
dotfilesdir=~/.dotfiles

# backup directory
backupdir=~/dotfiles_backup

# list of files/folders to symlink in homedir
dotfiles="bashrc bash_profile bash dir_colors inputrc"    

for dotfile in $dotfiles; do

	# remove existing symlinks
	[ -h ~/.$dotfile ] && rm ~/.$dotfile

	# move any existing files/dirs to $backupdir
    if [ -a ~/.$dotfile ]; then
    	[ ! -d $backupdir ] && mkdir -p $backupdir
    	echo "Moving existing ~/.$dotfile to $backupdir"
    	mv ~/.$dotfile $backupdir/$dotfile
    fi

    echo "Creating symlink to $dotfile in home directory."
    ln -s $dotfilesdir/$dotfile ~/.$dotfile
done
unset dotfile
