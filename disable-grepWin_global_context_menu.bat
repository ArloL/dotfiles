@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes

reg add "%registryRoot%\*\shell\grepWin..." /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\*\shell\grepWin..." /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Directory\background\shell\grepWin..." /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Directory\shell\grepWin..." /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Drive\shell\grepWin..." /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Folder\shell\grepWin..." /v LegacyDisable /t REG_SZ /f
