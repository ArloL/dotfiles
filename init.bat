@echo off

chcp 65001>nul

prompt [%USERNAME%@%COMPUTERNAME% $p]$_$$$s

rem Fake a UNIX environment

doskey clear=cls
doskey ls=dir /d $*
doskey cp=copy $*
doskey mv=move $*
doskey rm=del $*
doskey cat=type $*
doskey touch=type nul$G$G$*
doskey pwd=echo %CD%

rem Easier navigation

doskey cd=cd /D $*
doskey cd..=cd ..
doskey ..=cd ..
doskey ...=cd ../..
doskey ....=cd ../../..

rem List files properly

doskey l=dir /b $*
doskey ll=dir /b $*

rem Edit functionality

if exist ""%PROGRAMFILES%\Sublime Text 3"" (
    doskey edit="%PROGRAMFILES%\Sublime Text 3\sublime_text" $*
)
if exist ""%LOCALAPPDATA%\atom\app-1.4.0"" (
    doskey edit=atom $*
)
if exist ""%PROGRAMFILES(X86)%\Microsoft VS Code"" (
    doskey edit="%PROGRAMFILES(X86)%\Microsoft VS Code\bin\code.cmd" $*
)

rem Open functionality

doskey open=start $*

@echo on
