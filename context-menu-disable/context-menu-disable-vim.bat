@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes
set key=Vim

reg add "%registryRoot%\*\shell\%key%" /v LegacyDisable /t REG_SZ /f
