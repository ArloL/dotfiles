@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes
set key=TortoiseSVN

reg add "%registryRoot%\*\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\Directory\Background\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\Directory\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\Drive\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\Folder\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\InternetShortcut\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\LibraryFolder\background\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\LibraryLocation\shellex\ContextMenuHandlers\%key%" /d "---" /f
reg add "%registryRoot%\lnkfile\shellex\ContextMenuHandlers\%key%" /d "---" /f
