@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKLM\Software\Classes

reg delete %registryRoot%\Directory\background\shellex\ContextMenuHandlers\NvCplDesktopContext /f
reg delete %registryRoot%\Directory\background\shellex\ContextMenuHandlers\00nView /f
