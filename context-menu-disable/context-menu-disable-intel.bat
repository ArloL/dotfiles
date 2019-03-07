@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes
set key=igfxcui

reg add "%registryRoot%\Directory\Background\shellex\ContextMenuHandlers\%key%" /d "---" /f

set key=igfxDTCM

reg add "%registryRoot%\Directory\Background\shellex\ContextMenuHandlers\%key%" /d "---" /f
