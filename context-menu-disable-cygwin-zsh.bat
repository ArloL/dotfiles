@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes
set key=cygwin64_zsh

reg add "%registryRoot%\Directory\Background\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Directory\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Drive\Background\Shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Drive\Shell\%key%" /v LegacyDisable /t REG_SZ /f
