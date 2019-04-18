@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes
set key=OfficeScan NT

reg add "%registryRoot%\*\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\Drive\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\Directory\shellex\ContextMenuHandlers\%key%" /d "---" /f
