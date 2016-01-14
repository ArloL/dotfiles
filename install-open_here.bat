@echo off

setlocal EnableDelayedExpansion

set registryRoot=HKCU\Software\Classes\*\ContextMenus\open_here\Shell

reg add %registryRoot%\cmd /t REG_SZ /d "Eingabeaufforderung" /f
reg add %registryRoot%\cmd /v Icon /t REG_SZ /d "cmd.exe" /f
reg add %registryRoot%\cmd\command /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f

reg add %registryRoot%\powershell /t REG_SZ /d "PowerShell" /f
reg add %registryRoot%\powershell /v Icon /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\WindowsPowerShell\v1.0\powershell.exe" /f
reg add %registryRoot%\powershell\command /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\system32\WindowsPowerShell\v1.0\powershell.exe\"  -NoExit -Command Set-Location -LiteralPath \"%%V\"" /f

if exist ""%USERPROFILE%\bin\elevate.exe"" (
    reg add %registryRoot%\cmd_elevated /t REG_SZ /d "Eingabeaufforderung als Administrator" /f
    reg add %registryRoot%\cmd_elevated /v Icon /t REG_SZ /d "cmd.exe" /f
    reg add %registryRoot%\cmd_elevated\command /t REG_EXPAND_SZ /d "\"%%USERPROFILE%%\bin\elevate\" -k pushd \"%%V\"" /f
)

if exist ""%PROGRAMFILES%\Git"" (
    reg add %registryRoot%\git_bash /t REG_SZ /d "Git Bash" /f
    reg add %registryRoot%\git_bash /v Icon /t REG_EXPAND_SZ /d "%%PROGRAMFILES%%\Git\mingw64\share\git\git-for-windows.ico" /f
    reg add %registryRoot%\git_bash\command /t REG_EXPAND_SZ /d "\"%%PROGRAMFILES%%\Git\git-bash.exe\"" /f
    
    reg add %registryRoot%\git_cmd /t REG_SZ /d "Git CMD" /f
    reg add %registryRoot%\git_cmd /v Icon /t REG_EXPAND_SZ /d "%%PROGRAMFILES%%\Git\mingw64\share\git\git-for-windows.ico" /f
    reg add %registryRoot%\git_cmd\command /t REG_EXPAND_SZ /d "\"%%PROGRAMFILES%%\Git\git-cmd.exe\"" /f
)
if exist ""%CYGWIN_HOME%"" (
    reg add %registryRoot%\cygwin_mintty /t REG_SZ /d "Cygwin Mintty" /f
    reg add %registryRoot%\cygwin_mintty /v Icon /t REG_EXPAND_SZ /d "%%CYGWIN_HOME%%\Cygwin-Terminal.ico" /f
    reg add %registryRoot%\cygwin_mintty\command /t REG_EXPAND_SZ /d "\"%%CYGWIN_HOME%%\bin\mintty.exe\" -e /bin/xhere /bin/bash.exe \"%%V\"" /f
    
    reg add %registryRoot%\cygwin_cmd /t REG_SZ /d "Cygwin CMD" /f
    reg add %registryRoot%\cygwin_cmd /v Icon /t REG_EXPAND_SZ /d "%%CYGWIN_HOME%%\Cygwin-Terminal.ico" /f
    reg add %registryRoot%\cygwin_cmd\command /t REG_EXPAND_SZ /d "\"%%CYGWIN_HOME%%\bin\bash\" -c \"/bin/xhere /bin/bash.exe '%%V'\"" /f
)
if exist ""%PROGRAMFILES%\Sublime Text 3"" (
    reg add %registryRoot%\sublime /t REG_SZ /d "Sublime Text 3" /f
    reg add %registryRoot%\sublime /v Icon /t REG_EXPAND_SZ /d "%%PROGRAMFILES%%\Sublime Text 3\sublime_text.exe" /f
    reg add %registryRoot%\sublime\command /t REG_EXPAND_SZ /d "\"%%PROGRAMFILES%%\Sublime Text 3\sublime_text.exe\" \"%%V\"" /f
)
if exist ""%PROGRAMFILES(X86)%\Atlassian\SourceTree"" (
    reg add %registryRoot%\sourcetree /t REG_SZ /d "SourceTree" /f
    reg add %registryRoot%\sourcetree /v Icon /t REG_EXPAND_SZ /d "%%PROGRAMFILES(X86)%%\Atlassian\SourceTree\SourceTree.exe" /f
    reg add %registryRoot%\sourcetree\command /t REG_EXPAND_SZ /d "\"%%PROGRAMFILES(X86)%%\Atlassian\SourceTree\SourceTree.exe\" -f \"%%V\"" /f
)
if exist ""%PROGRAMFILES(X86)%\Microsoft VS Code"" (
    reg add %registryRoot%\visualstudiocode /t REG_SZ /d "Visual Studio Code" /f
    reg add %registryRoot%\visualstudiocode /v Icon /t REG_EXPAND_SZ /d "%%PROGRAMFILES(X86)%%\Microsoft VS Code\code.exe" /f
    reg add %registryRoot%\visualstudiocode\command /t REG_EXPAND_SZ /d "\"%%PROGRAMFILES(X86)%%\Microsoft VS Code\code.exe\" \"%%V\"" /f
)
if exist ""%PROGRAMFILES%\grepWin"" (
    reg add %registryRoot%\grepWin /t REG_SZ /d "grepWin" /f
    reg add %registryRoot%\grepWin /v Icon /t REG_EXPAND_SZ /d "%%PROGRAMFILES%%\grepWin\grepWin.exe,-107" /f
    reg add %registryRoot%\grepWin\command /t REG_EXPAND_SZ /d "\"%%PROGRAMFILES%%\grepWin\grepWin.exe\" /searchpath:\"%%V\"" /f
)
if exist ""%LOCALAPPDATA%\atom\app-1.4.0"" (
    reg add %registryRoot%\atom /t REG_SZ /d "Atom" /f
    reg add %registryRoot%\atom /v Icon /t REG_EXPAND_SZ /d "%%LOCALAPPDATA%%\atom\app-1.4.0\atom.exe" /f
    reg add %registryRoot%\atom\command /t REG_EXPAND_SZ /d "\"%%LOCALAPPDATA%%\atom\app-1.4.0\atom.exe\" \"%%V\"" /f
)

reg add HKCU\Software\Classes\Drive\shell\open_here /t REG_SZ /d "Open here" /f
reg add HKCU\Software\Classes\Drive\shell\open_here /v ExtendedSubCommandsKey /t REG_SZ /d "*\\ContextMenus\open_here" /f

reg add HKCU\Software\Classes\Drive\Background\shell\open_here /t REG_SZ /d "Open here" /f
reg add HKCU\Software\Classes\Drive\Background\shell\open_here /v ExtendedSubCommandsKey /t REG_SZ /d "*\\ContextMenus\open_here" /f

reg add HKCU\Software\Classes\Directory\shell\open_here /t REG_SZ /d "Open here" /f
reg add HKCU\Software\Classes\Directory\shell\open_here /v ExtendedSubCommandsKey /t REG_SZ /d "*\\ContextMenus\open_here" /f

reg add HKCU\Software\Classes\Directory\Background\shell\open_here /t REG_SZ /d "Open here" /f
reg add HKCU\Software\Classes\Directory\Background\shell\open_here /v ExtendedSubCommandsKey /t REG_SZ /d "*\\ContextMenus\open_here" /f
