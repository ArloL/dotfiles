@echo off
setlocal enabledelayedexpansion

set sourcetreepath=SourceTree\SourceTree.exe
if exist "%programfiles%\Atlassian\%sourcetreepath%" (
    set sourcetreepath=%programfiles%\Atlassian\%sourcetreepath%
) else if exist "%programfiles(x86)%\Atlassian\%sourcetreepath%" (
    set "sourcetreepath=%programfiles(x86)%\Atlassian\%sourcetreepath%"
) else if exist "%localappdata%\%sourcetreepath%" (
    set sourcetreepath=%localappdata%\%sourcetreepath%
) else (
    echo [Error]: Could not find SourceTree.exe - is it installed? 1>&2
    goto :eof
) 

REM Convert the first argument to a full path
set directory=%~f1
REM If the first argument is empty use the current directory
if "%directory%" == "" set directory=%CD%

REM If the first argument is not a directory (e.g. a file) remove the filename
if exist "%directory%\" (
    set directory=%directory%
) else (
    set directory=%~dp1
)

REM go to the target directory
pushd "%directory%"

REM get the root of the repository
for /f "delims=" %%i in ('git rev-parse --show-toplevel') do set directory=%%i
git rev-parse --show-toplevel 1> nul 2> nul

if %errorlevel% EQU 0 (
    start "" "%sourcetreepath%" -f "%directory:/=\%"
)

popd
endlocal
