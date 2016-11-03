@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes

reg delete %registryRoot%\*\shell\grepWin... /f
reg delete %registryRoot%\*\shell\grepWin... /f
reg delete %registryRoot%\Directory\background\shell\grepWin... /f
reg delete %registryRoot%\Directory\shell\grepWin... /f
reg delete %registryRoot%\Drive\shell\grepWin... /f
reg delete %registryRoot%\Folder\shell\grepWin... /f
