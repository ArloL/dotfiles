@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKLM\Software\Classes\Directory\background\shellex

reg delete %registryRoot%\ContextMenuHandlers\NvCplDesktopContext /f
reg delete %registryRoot%\ContextMenuHandlers\00nView /f
