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
    reg import cygwin.reg
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
