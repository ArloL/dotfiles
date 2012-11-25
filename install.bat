@echo off

setlocal EnableDelayedExpansion

:: ############################
:: # Create symlinks from the home directory to any desired dotfiles directory.
:: ############################

:: dotfiles directory
set dotfilesdir=%USERPROFILE%\.dotfiles

:: backup directory
set backupdir=%USERPROFILE%\dotfiles_backup

:: list of files/folders to symlink in homedir
set dotfiles=bashrc bash_profile bash dir_colors inputrc minttyrc gitconfig    

for %%A in (%dotfiles%) DO (
  set target=%dotfilesdir%\%%A
  set link=%USERPROFILE%\.%%A
  set linkExists="0"

  if exist "!link!" (
    set Z=&& for %%B in ("!link!") do set Z=%%~aB
    if "!Z:~8,1!" == "l" (
      set linkExists="1"
    ) else (
      if not exist "%backupdir%" (
        mkdir "%backupdir%""
      )
      echo Moving existing !link! to %backupdir%
      move "!link!" "%backupdir%"
    )
  )
  
  if !linkExists! == "0" (
    if exist "!target!\" (
      mklink /d "!link!" "!target!"
    ) else (
      mklink "!link!" "!target!"
    )
  )
)
