@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes
set key=AddToPlaylistVLC

reg add "%registryRoot%\Directory\shell\%key%" /v LegacyDisable /t REG_SZ /f

set key=PlayWithVLC

reg add "%registryRoot%\Directory\shell\%key%" /v LegacyDisable /t REG_SZ /f
