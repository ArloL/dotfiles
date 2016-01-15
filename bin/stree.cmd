@echo off
set directory=%~f1
if %directory:~-1%==\ set directory=%directory:~0,-1%
start "" "C:\Program Files (x86)\Atlassian\SourceTree\SourceTree.exe" -f %directory%
