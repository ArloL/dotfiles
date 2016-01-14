@echo off

NET SESSION >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Not an admin, exiting.
    exit /B 1
)

setlocal EnableDelayedExpansion

reg import open_here.reg
reg import cmd.reg
reg import powershell.reg
if exist "C:\Program Files\Git" (
    reg import git_bash.reg
)
if exist "%CYGWIN_HOME%" (
    reg import cygwin_cmd.reg
    reg import cygwin_mintty.reg
)
if exist "C:\Program Files\Sublime Text 3" (
    reg import sublime_text.reg
)
if exist "C:\Program Files (x86)\Atlassian\SourceTree" (
    reg import sourcetree.reg
)
if exist "C:\Program Files (x86)\Microsoft VS Code" (
    reg import visualstudiocode.reg
)
if exist "%PROGRAMFILES%\grepWin" (
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\grepWin /t REG_SZ /d "grepWin" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\grepWin /v Icon /t REG_EXPAND_SZ /d "%%PROGRAMFILES%%\grepWin\grepWin.exe,-107" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\grepWin\command /t REG_EXPAND_SZ /d "\"%%PROGRAMFILES%%\grepWin\grepWin.exe\" /searchpath:\"%%V\"" /f
)
if exist "%LOCALAPPDATA%\atom\app-1.4.0" (
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\atom /t REG_SZ /d "Atom" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\atom /v Icon /t REG_EXPAND_SZ /d "%%LOCALAPPDATA%%\atom\app-1.4.0\atom.exe" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\atom\command /t REG_EXPAND_SZ /d "\"%%LOCALAPPDATA%%\atom\app-1.4.0\atom.exe\" \"%%V\"" /f
)
