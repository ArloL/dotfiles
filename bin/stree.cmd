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

set directory=%~f1
if "%directory%" == "" set directory=%CD%
echo %directory%

if exist "%directory%\NUL" (
    set directory=%directory%
) else (
    set directory=%~dp1
)

pushd %directory%

for /f "delims=" %%i in ('git rev-parse --show-toplevel') do set directory=%%i
git rev-parse --show-toplevel 1> nul 2> nul

if %errorlevel% EQU 0 (
    start "" "%sourcetreepath%" -f "%directory:/=\%" log
)

popd
endlocal
