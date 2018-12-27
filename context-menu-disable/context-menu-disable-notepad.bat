@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes
set key=ANotepad++64

reg add "%registryRoot%\*\shellex\ContextMenuHandlers\%key%" /d "---" /f
