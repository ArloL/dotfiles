@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes
set key=Open with Sublime Text

reg add "%registryRoot%\*\shell\%key%" /v LegacyDisable /t REG_SZ /f
