reg add HKCU\Software\Classes\*\ContextMenus\open_here\shell\cygwin /ve /d "Cygwin" /f
reg add HKCU\Software\Classes\*\ContextMenus\open_here\shell\cygwin\command /t REG_EXPAND_SZ /ve /d "%%CYGWIN_HOME%%\bin\bash -c \"/bin/xhere /bin/bash.exe '%%V'\"" /f
