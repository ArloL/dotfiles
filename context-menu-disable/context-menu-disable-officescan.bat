@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes
set key=OfficeScan NT

reg add "%registryRoot%\*\shellex\ContextMenuHandlers\%key%" /d "---" /f
