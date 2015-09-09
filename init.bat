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
doskey touch=type nul>>$*

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

IF NOT EXIST "C:\Program Files\Sublime Text 3" GOTO NOSUBLIME
    doskey edit="C:\Program Files\Sublime Text 3\sublime_text" $*
:NOSUBLIME

rem Open functionality

doskey open=start $*

@echo on
