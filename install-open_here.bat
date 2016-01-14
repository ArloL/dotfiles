@echo off

setlocal EnableDelayedExpansion

reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\cmd /t REG_SZ /d "Eingabeaufforderung" /f
reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\cmd /v Icon /t REG_SZ /d "cmd.exe" /f
reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\cmd\command /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f

reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\powershell /t REG_SZ /d "PowerShell" /f
reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\powershell /v Icon /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\WindowsPowerShell\v1.0\powershell.exe" /f
reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\powershell\command /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\system32\WindowsPowerShell\v1.0\powershell.exe\"  -NoExit -Command Set-Location -LiteralPath \"%%V\"" /f

if exist ""%PROGRAMFILES%\Git"" (
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\git_bash /t REG_SZ /d "Git Bash" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\git_bash /v Icon /t REG_EXPAND_SZ /d "%%PROGRAMFILES%%\Git\mingw64\share\git\git-for-windows.ico" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\git_bash\command /t REG_EXPAND_SZ /d "\"%%PROGRAMFILES%%\Git\git-bash.exe\"" /f
    
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\git_cmd /t REG_SZ /d "Git CMD" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\git_cmd /v Icon /t REG_EXPAND_SZ /d "%%PROGRAMFILES%%\Git\mingw64\share\git\git-for-windows.ico" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\git_cmd\command /t REG_EXPAND_SZ /d "\"%%PROGRAMFILES%%\Git\git-cmd.exe\"" /f
)
if exist ""%CYGWIN_HOME%"" (
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\cygwin_mintty /t REG_SZ /d "Cygwin Mintty" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\cygwin_mintty /v Icon /t REG_EXPAND_SZ /d "%%CYGWIN_HOME%%\Cygwin-Terminal.ico" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\cygwin_mintty\command /t REG_EXPAND_SZ /d "\"%%CYGWIN_HOME%%\bin\mintty.exe\" -e /bin/xhere /bin/bash.exe \"%%V\"" /f
    
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\cygwin_cmd /t REG_SZ /d "Cygwin CMD" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\cygwin_cmd /v Icon /t REG_EXPAND_SZ /d "%%CYGWIN_HOME%%\Cygwin-Terminal.ico" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\cygwin_cmd\command /t REG_EXPAND_SZ /d "\"%%CYGWIN_HOME%%\bin\bash\" -c \"/bin/xhere /bin/bash.exe '%%V'\"" /f
)
if exist ""%PROGRAMFILES%\Sublime Text 3"" (
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\sublime /t REG_SZ /d "Sublime Text 3" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\sublime /v Icon /t REG_EXPAND_SZ /d "%%PROGRAMFILES%%\Sublime Text 3\sublime_text.exe" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\sublime\command /t REG_EXPAND_SZ /d "\"%%PROGRAMFILES%%\Sublime Text 3\sublime_text.exe\" \"%%V\"" /f
)
if exist ""%PROGRAMFILES(X86)%\Atlassian\SourceTree"" (
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\sourcetree /t REG_SZ /d "SourceTree" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\sourcetree /v Icon /t REG_EXPAND_SZ /d "%%PROGRAMFILES(X86)%%\Atlassian\SourceTree\SourceTree.exe" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\sourcetree\command /t REG_EXPAND_SZ /d "\"%%PROGRAMFILES(X86)%%\Atlassian\SourceTree\SourceTree.exe\" -f \"%%V\"" /f
)
if exist ""%PROGRAMFILES(X86)%\Microsoft VS Code"" (
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\visualstudiocode /t REG_SZ /d "Visual Studio Code" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\visualstudiocode /v Icon /t REG_EXPAND_SZ /d "%%PROGRAMFILES(X86)%%\Microsoft VS Code\code.exe" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\visualstudiocode\command /t REG_EXPAND_SZ /d "\"%%PROGRAMFILES(X86)%%\Microsoft VS Code\code.exe\" \"%%V\"" /f
)
if exist ""%PROGRAMFILES%\grepWin"" (
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\grepWin /t REG_SZ /d "grepWin" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\grepWin /v Icon /t REG_EXPAND_SZ /d "%%PROGRAMFILES%%\grepWin\grepWin.exe,-107" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\grepWin\command /t REG_EXPAND_SZ /d "\"%%PROGRAMFILES%%\grepWin\grepWin.exe\" /searchpath:\"%%V\"" /f
)
if exist ""%LOCALAPPDATA%\atom\app-1.4.0"" (
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\atom /t REG_SZ /d "Atom" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\atom /v Icon /t REG_EXPAND_SZ /d "%%LOCALAPPDATA%%\atom\app-1.4.0\atom.exe" /f
    reg add HKCU\Software\Classes\*\ContextMenus\open_here\Shell\atom\command /t REG_EXPAND_SZ /d "\"%%LOCALAPPDATA%%\atom\app-1.4.0\atom.exe\" \"%%V\"" /f
)

reg add HKCU\Software\Classes\Drive\shell\open_here /t REG_SZ /d "Open here" /f
reg add HKCU\Software\Classes\Drive\shell\open_here /v ExtendedSubCommandsKey /t REG_SZ /d "*\\ContextMenus\open_here" /f

reg add HKCU\Software\Classes\Drive\Background\shell\open_here /t REG_SZ /d "Open here" /f
reg add HKCU\Software\Classes\Drive\Background\shell\open_here /v ExtendedSubCommandsKey /t REG_SZ /d "*\\ContextMenus\open_here" /f

reg add HKCU\Software\Classes\Directory\shell\open_here /t REG_SZ /d "Open here" /f
reg add HKCU\Software\Classes\Directory\shell\open_here /v ExtendedSubCommandsKey /t REG_SZ /d "*\\ContextMenus\open_here" /f

reg add HKCU\Software\Classes\Directory\Background\shell\open_here /t REG_SZ /d "Open here" /f
reg add HKCU\Software\Classes\Directory\Background\shell\open_here /v ExtendedSubCommandsKey /t REG_SZ /d "*\\ContextMenus\open_here" /f
