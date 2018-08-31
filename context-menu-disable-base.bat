@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes
set key=grepWin...

reg add "%registryRoot%\*\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Directory\background\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Directory\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Drive\Background\Shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Drive\shell\%key%" /v LegacyDisable /t REG_SZ /f
reg add "%registryRoot%\Folder\shell\%key%" /v LegacyDisable /t REG_SZ /f

reg add "%registryRoot%\*\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\Directory\Background\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\Directory\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\Drive\Background\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\Drive\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\Folder\shellex\ContextMenuHandlers\%key%" /d "---" /f
