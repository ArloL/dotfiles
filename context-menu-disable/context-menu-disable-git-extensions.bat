@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes
set key=GitExtensions2

reg add "%registryRoot%\*\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\Directory\Background\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\Directory\shellex\ContextMenuHandlers\%key%" /d "---" /f
