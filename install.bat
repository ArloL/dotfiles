@echo off

NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO Not an admin, exiting.
    EXIT /B 1
)

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
    attrib /L "!link!" +h
  )
)

if exist "%USERPROFILE%\AppData\Roaming\Sublime Text 2" (
  cd "%USERPROFILE%\AppData\Roaming\Sublime Text 2"
  mkdir "Backup"
  move "Installed Packages" "Backup"
  move "Packages" "Backup"
  move "Pristine Packages" "Backup"
  mklink /D "Installed Packages" "%USERPROFILE%\.dotfiles\sublime\Installed Packages"
  mklink /D "Packages" "%USERPROFILE%\.dotfiles\sublime\Packages"
  mklink /D "Pristine Packages" "%USERPROFILE%\.dotfiles\sublime\Pristine Packages"
)
