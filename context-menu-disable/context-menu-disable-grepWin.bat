@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes
set key=grepWin...

reg add "%registryRoot%\*\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Directory\background\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Directory\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Drive\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Folder\shell\%key%" /v LegacyDisable /t REG_SZ /f

set key=grepWin

reg add "%registryRoot%\*\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Directory\background\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Directory\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Drive\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Folder\shell\%key%" /v LegacyDisable /t REG_SZ /f
