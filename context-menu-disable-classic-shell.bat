@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes
set key=StartMenuExt

reg add "%registryRoot%\Folder\shellex\ContextMenuHandlers\%key%" /d "---" /f
