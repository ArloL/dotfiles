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
set dotfiles=bashrc bash_profile config minttyrc gitconfig zshrc puppet-lint.rc

:: add registry key for init.bat
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "%dotfilesDir%init.bat" /f

if exist "%HOME%" (
	set homeDir=%HOME%
) else (
	if exist "%HOMEDRIVE%%HOMEPATH%" (
		set homeDir=%HOMEDRIVE%%HOMEPATH%
	) else (
		set homeDir=%USERPROFILE%
	)
)

IF %homeDir:~-1%==\ SET homeDir=%homeDir:~0,-1%

for %%A in (%dotfiles%) DO (
    call:createSymLink "%dotfilesDir%%%A" "%homeDir%\.%%A" "%backupDir%" true
)

call:createSymLink "%dotfilesDir%config\readline\inputrc" "%homeDir%\.inputrc" "%backupDir%" true

set sublimeDir=%APPDATA%\Sublime Text 3\Packages
set backupDir=%sublimeDir%\dotfiles_backup

if exist "%sublimeDir%" (
    call:createSymLink "%dotfilesDir%sublime\User" "%sublimeDir%\User" "%backupDir%" false
)

Powershell.exe -executionpolicy remotesigned -File install-win.ps1 %dotfilesDir%Microsoft.PowerShell_profile.ps1

cd open_here
call install.bat

goto:EOF

::function
:createSymLink - target linkName backupDirectory hideLink
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
        if %4 == "true" (
        	attrib /L "%~2" +h
        )
    ) else (
        echo Not replacing existing link %2
    )

goto:EOF
