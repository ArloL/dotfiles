@echo off
:: ############################
:: # Install the dotfiles on Windows systems.
:: ############################

NET SESSION >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Not an admin, exiting.
    exit /B 1
)

setlocal EnableDelayedExpansion

set dotfilesDir=%~dp0
set backupDir=%USERPROFILE%\dotfiles_backup
set dotfiles=bashrc bash_profile bash dir_colors inputrc minttyrc gitconfig shell zshrc zsh

:: add registry key for init.bat
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "%dotfilesDir%init.bat" /f

for %%A in (%dotfiles%) DO (
    call:createSymLink "%dotfilesDir%%%A" "%HOMEDRIVE%%HOMEPATH%\.%%A" "%backupDir%"
)

set sublimeDir=%USERPROFILE%\AppData\Roaming\Sublime Text 2
set backupDir=%sublimeDir%\dotfiles_backup

if exist "%sublimeDir%" (
    call:createSymLink "%dotfilesDir%sublime\Installed Packages" "%sublimeDir%\Installed Packages" "%backupDir%"
    call:createSymLink "%dotfilesDir%sublime\Packages" "%sublimeDir%\Packages" "%backupDir%"
    call:createSymLink "%dotfilesDir%sublime\Pristine Packages" "%sublimeDir%\Pristine Packages" "%backupDir%"
)

goto:EOF

::function
:createSymLink - target linkName backupDirectory
    set linkExists="0"
    if exist "%~2" (
        set Z=&& for %%A in ("%~2") do set Z=%%~aA
        if "!Z:~8,1!" == "l" (
            set linkExists="1"
        ) else (
            if not exist "%~3" (
                mkdir "%~3"
            )
            echo Moving existing %2 to %3
            move "%~2" "%~3"
        )
    )

    if !linkExists! == "0" (
        if exist "%~1\" (
            mklink /d "%~2" "%~1"
        ) else (
            mklink "%~2" "%~1"
        )
        attrib /L "%~2" +h
    ) else (
        echo Not replacing existing link %2
    )

goto:EOF
