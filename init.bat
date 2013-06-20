@echo off

cls

chcp 65001>nul

rem old prompt: [%USERNAME%@%COMPUTERNAME% $p]

prompt $$$s

rem Fake a UNIX environment

doskey clear=cls
doskey ls=dir /b $*
doskey cp=copy $*
doskey mv=move $*
doskey rm=del $*
doskey cat=type $*
doskey pwd=echo %CD%

rem Easier navigation

doskey cd=cd /D $*
doskey cd..=cd ..
doskey ..=cd ..
doskey ...=cd ../..
doskey ....=cd ../../..

rem List files properly

doskey l=ls
doskey ll=ls

rem Edit functionality

IF NOT EXIST "C:\Program Files\Sublime Text 2" GOTO NOSUBLIME
    doskey edit="C:\Program Files\Sublime Text 2\sublime_text" $*
:NOSUBLIME

rem Open functionality

doskey open=start $*

@echo on
