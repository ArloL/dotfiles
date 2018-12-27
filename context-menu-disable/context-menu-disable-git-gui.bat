@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes
set key=git_gui

reg add "%registryRoot%\Directory\background\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Directory\shell\%key%" /v LegacyDisable /t REG_SZ /f
