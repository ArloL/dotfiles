reg add HKCU\Software\Classes\*\ContextMenus\open_here\shell\powershell /ve /d "PowerShell" /f
reg add HKCU\Software\Classes\*\ContextMenus\open_here\shell\powershell\command /t REG_EXPAND_SZ /ve /d "%%SystemRoot%%"\system32\WindowsPowerShell\v1.0\powershell.exe" -NoExit -Command Set-Location -LiteralPath '%%V'" /f
