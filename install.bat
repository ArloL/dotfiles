@echo off

NET SESSION >nul 2>&1
if %ERRORLEVEL% neq 0 (
  echo Not an admin, exiting.
  exit /B 1
)

setlocal EnableDelayedExpansion

:: ############################
:: # Create symlinks from the home directory to any desired dotfiles directory.
:: ############################

:: dotfiles directory
set dotfilesdir=%~dp0

:: backup directory
set backupdir=%USERPROFILE%\dotfiles_backup

:: list of files/folders to symlink in homedir
set dotfiles=bashrc bash_profile bash dir_colors inputrc minttyrc gitconfig shell zshrc zsh zprofile

for %%A in (%dotfiles%) DO (
  set target=%dotfilesdir%%%A
  set link=%USERPROFILE%\.%%A
  set linkExists="0"

  if exist "!link!" (
    set Z=&& for %%B in ("!link!") do set Z=%%~aB
    if "!Z:~8,1!" == "l" (
      set linkExists="1"
    ) else (
      if not exist "%backupdir%" (
        mkdir "%backupdir%"
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

set sublime=%USERPROFILE%\AppData\Roaming\Sublime Text 2

if exist "%sublime%" (
  mkdir "%sublime%\Backup"
  move "%sublime%\Installed Packages" "%sublime%\Backup"
  move "%sublime%\Packages" "%sublime%\Backup"
  move "%sublime%\Pristine Packages" "%sublime%\Backup"
  mklink /d "%sublime%\Installed Packages" "%~dp0sublime\Installed Packages"
  mklink /d "%sublime%\Packages" "%~dp0sublime\Packages"
  mklink /d "%sublime%\Pristine Packages" "%~dp0sublime\Pristine Packages"
)

mklink %USERPROFILE%\init.bat "%dotfilesdir%\init.bat"
