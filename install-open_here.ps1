$registryRoot = "HKCU:\Software\Classes\*\ContextMenus\open_here\Shell"

$elevate = ${Env:UserProfile} + "\bin\elevate.exe"
$git = ${Env:ProgramFiles} + "\Git\"
$cygwin = ${Env:CYGWIN_HOME}
$sublimeText = ${Env:ProgramFiles} + "\Sublime Text 3\"
$sourceTree = ${Env:ProgramFiles(x86)} + "\Atlassian\SourceTree\"
$sourceTree2 = ${Env:LocalAppData} + "\SourceTree"
$vsCodeX86 = ${Env:ProgramFiles(x86)} + "\Microsoft VS Code"
$vsCode = ${Env:ProgramFiles} + "\Microsoft VS Code"
$grepWin = ${Env:ProgramFiles} + "\grepWin"
$atom = ${Env:LocalAppData} + "\atom\Update.exe"
$gitExtensions = ${Env:ProgramFiles(X86)} + "GitExtensions"

New-Item -Path $registryRoot\cmd -Value "Eingabeaufforderung" -ItemType String -Force
New-ItemProperty -Path $registryRoot\cmd -Name Icon -Value "cmd.exe" -PropertyType String -Force
New-Item -Path $registryRoot\cmd\command -Value 'cmd.exe /s /k pushd "%V"' -ItemType String -Force

New-Item -Path $registryRoot\powershell -Value "PowerShell" -ItemType String -Force
New-ItemProperty -Path $registryRoot\powershell -Name Icon -Value '%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe' -PropertyType ExpandString -Force
New-Item -Path $registryRoot\powershell\command -Value '"%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe" -NoExit -Command Set-Location -LiteralPath "%V"' -ItemType ExpandString -Force

if (Test-Path $elevate) {
    New-Item -Path $registryRoot\cmd_elevated -Value "Eingabeaufforderung als Administrator" -ItemType String -Force
    New-ItemProperty -Path $registryRoot\cmd_elevated -Name Icon -Value "cmd.exe" -PropertyType String -Force
    New-Item -Path $registryRoot\cmd_elevated\command -Value '"%USERPROFILE%\bin\elevate.exe" -k pushd "%V"' -ItemType ExpandString -Force

    New-Item -Path $registryRoot\powershell_elevated -Value "PowerShell als Administrator" -ItemType String -Force
    New-ItemProperty -Path $registryRoot\powershell_elevated -Name Icon -Value '%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe' -PropertyType ExpandString -Force
    New-Item -Path $registryRoot\powershell_elevated\command -Value '"%USERPROFILE%\bin\elevate.exe" -k  "%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe"' -ItemType ExpandString -Force
} else {
    Remove-Item -Recurse -Path $registryRoot\cmd_elevated -Force
    Remove-Item -Recurse -Path $registryRoot\powershell_elevated -Force
}

if (Test-Path $git) {
    New-Item -Path $registryRoot\git_bash -Value "Git Bash" -ItemType String -Force
    New-ItemProperty -Path $registryRoot\git_bash -Name Icon -Value '%ProgramFiles%\Git\mingw64\share\git\git-for-windows.ico' -PropertyType ExpandString -Force
    New-Item -Path $registryRoot\git_bash\command -Value '"%PROGRAMFILES%\Git\git-bash.exe"' -ItemType ExpandString -Force

    New-Item -Path $registryRoot\git_cmd -Value "Git CMD" -ItemType String -Force
    New-ItemProperty -Path $registryRoot\git_cmd -Name Icon -Value '%ProgramFiles%\Git\mingw64\share\git\git-for-windows.ico' -PropertyType ExpandString -Force
    New-Item -Path $registryRoot\git_cmd\command -Value '"%PROGRAMFILES%\Git\git-cmd.exe"' -ItemType ExpandString -Force
} else {
    Remove-Item -Recurse -Path $registryRoot\git_bash -Force
    Remove-Item -Recurse -Path $registryRoot\git_cmd -Force
}

if (($cygwin) -and (Test-Path $cygwin)) {
    New-Item -Path $registryRoot\cygwin_mintty -Value "Cygwin Mintty" -ItemType String -Force
    New-ItemProperty -Path $registryRoot\cygwin_mintty -Name Icon -Value '%CYGWIN_HOME%\Cygwin-Terminal.ico' -PropertyType ExpandString -Force
    New-Item -Path $registryRoot\cygwin_mintty\command -Value '"%CYGWIN_HOME%\bin\mintty.exe" -e /bin/xhere /bin/bash.exe "%V"' -ItemType ExpandString -Force

    New-Item -Path $registryRoot\cygwin_cmd -Value "Cygwin CMD" -ItemType String -Force
    New-ItemProperty -Path $registryRoot\cygwin_cmd -Name Icon -Value '%CYGWIN_HOME%\Cygwin-Terminal.ico' -PropertyType ExpandString -Force
    New-Item -Path $registryRoot\cygwin_cmd\command -Value '"%CYGWIN_HOME%\bin\bash.exe" -c "/bin/xhere /bin/bash.exe ''%V''"' -ItemType ExpandString -Force
} else {
    Remove-Item -Recurse -Path $registryRoot\cygwin_mintty -Force
    Remove-Item -Recurse -Path $registryRoot\cygwin_cmd -Force
}

if (Test-Path $sublimeText) {
    New-Item -Path $registryRoot\sublime -Value "Sublime Text 3" -ItemType String -Force
    New-ItemProperty -Path $registryRoot\sublime -Name Icon -Value '%PROGRAMFILES%\Sublime Text 3\sublime_text.exe' -PropertyType ExpandString -Force
    New-Item -Path $registryRoot\sublime\command -Value '"%PROGRAMFILES%\Sublime Text 3\sublime_text.exe" "%V"' -ItemType ExpandString -Force
} else {
    Remove-Item -Recurse -Path $registryRoot\sublime -Force
}

if (Test-Path $sourceTree) {
    New-Item -Path $registryRoot\sourcetree -Value "SourceTree" -ItemType String -Force
    New-ItemProperty -Path $registryRoot\sourcetree -Name Icon -Value '%PROGRAMFILES(X86)%\Atlassian\SourceTree\SourceTree.exe' -PropertyType ExpandString -Force
    New-Item -Path $registryRoot\sourcetree\command -Value '"%PROGRAMFILES(X86)%\Atlassian\SourceTree\SourceTree.exe" -f "%V"' -ItemType ExpandString -Force
} else {
    Remove-Item -Recurse -Path $registryRoot\sourcetree -Force
}

if ((Test-Path $sourceTree2) -and !(Test-Path $sourceTree2\.dead)) {
    New-Item -Path $registryRoot\sourcetree2 -Value "SourceTree 2" -ItemType String -Force
    New-ItemProperty -Path $registryRoot\sourcetree2 -Name Icon -Value '%LOCALAPPDATA%\SourceTree\SourceTree.exe' -PropertyType ExpandString -Force
    New-Item -Path $registryRoot\sourcetree2\command -Value '"%LOCALAPPDATA%\SourceTree\Update.exe" --processStart "SourceTree.exe" --process-start-args "-f "%V""' -ItemType ExpandString -Force
} else {
    Remove-Item -Recurse -Path $registryRoot\sourcetree2 -Force
}

if (Test-Path $vsCodeX86) {
    New-Item -Path $registryRoot\visualstudiocode -Value "Visual Studio Code" -ItemType String -Force
    New-ItemProperty -Path $registryRoot\visualstudiocode -Name Icon -Value '%PROGRAMFILES(X86)%\Microsoft VS Code\code.exe' -PropertyType ExpandString -Force
    New-Item -Path $registryRoot\visualstudiocode\command -Value '"%PROGRAMFILES(X86)%\Microsoft VS Code\code.exe" "%V"' -ItemType ExpandString -Force
} else {
    Remove-Item -Recurse -Path $registryRoot\visualstudiocode -Force
}

if (Test-Path $vsCode) {
    New-Item -Path $registryRoot\visualstudiocode -Value "Visual Studio Code" -ItemType String -Force
    New-ItemProperty -Path $registryRoot\visualstudiocode -Name Icon -Value '%PROGRAMFILES%\Microsoft VS Code\code.exe' -PropertyType ExpandString -Force
    New-Item -Path $registryRoot\visualstudiocode\command -Value '"%PROGRAMFILES%\Microsoft VS Code\code.exe" "%V"' -ItemType ExpandString -Force
} else {
    Remove-Item -Recurse -Path $registryRoot\visualstudiocode -Force
}

if (Test-Path $grepWin) {
    New-Item -Path $registryRoot\grepWin -Value "grepWin" -ItemType String -Force
    New-ItemProperty -Path $registryRoot\grepWin -Name Icon -Value '%PROGRAMFILES%\grepWin\grepWin.exe,-107' -PropertyType ExpandString -Force
    New-Item -Path $registryRoot\grepWin\command -Value '"%PROGRAMFILES%\grepWin\grepWin.exe" /searchpath:"%V"' -ItemType ExpandString -Force
} else {
    Remove-Item -Recurse -Path $registryRoot\grepWin -Force
}

if ((Test-Path $atom) -and !(Test-Path $atom\.dead)) {
    New-Item -Path $registryRoot\atom -Value "Atom" -ItemType String -Force
    New-ItemProperty -Path $registryRoot\atom -Name Icon -Value '%LOCALAPPDATA%\atom\app.ico' -PropertyType ExpandString -Force
    New-Item -Path $registryRoot\atom\command -Value '"%LOCALAPPDATA%\atom\Update.exe" --processStart "atom.exe" --process-start-args "%V"' -ItemType ExpandString -Force
} else {
    Remove-Item -Recurse -Path $registryRoot\atom -Force
}

if (Test-Path $gitExtensions) {
    New-Item -Path $registryRoot\gitextensions -Value "GitExtensions" -ItemType String -Force
    New-ItemProperty -Path $registryRoot\gitextensions -Name Icon -Value '%PROGRAMFILES(X86)%\GitExtensions\GitExtensions.exe' -PropertyType ExpandString -Force
    New-Item -Path $registryRoot\gitextensions\command -Value '"%PROGRAMFILES(X86)%\GitExtensions\GitExtensions.exe" openrepo "%V"' -ItemType ExpandString -Force
} else {
    Remove-Item -Recurse -Path $registryRoot\gitextensions -Force
}

New-Item -Path "HKCU:\Software\Classes\Drive\shell\open_here" -Value "Open here" -ItemType String -Force
New-ItemProperty -Path "HKCU:\Software\Classes\Drive\shell\open_here" -Name ExtendedSubCommandsKey -Value "*\ContextMenus\open_here" -PropertyType String -Force

New-Item -Path "HKCU:\Software\Classes\Drive\Background\shell\open_here" -Value "Open here" -ItemType String -Force
New-ItemProperty -Path "HKCU:\Software\Classes\Drive\Background\shell\open_here" -Name ExtendedSubCommandsKey -Value "*\ContextMenus\open_here" -PropertyType String -Force

New-Item -Path "HKCU:\Software\Classes\Directory\shell\open_here" -Value "Open here" -ItemType String -Force
New-ItemProperty -Path "HKCU:\Software\Classes\Directory\shell\open_here" -Name ExtendedSubCommandsKey -Value "*\ContextMenus\open_here" -PropertyType String -Force

New-Item -Path "HKCU:\Software\Classes\Directory\Background\shell\open_here" -Value "Open here" -ItemType String -Force
New-ItemProperty -Path "HKCU:\Software\Classes\Directory\Background\shell\open_here" -Name ExtendedSubCommandsKey -Value "*\ContextMenus\open_here" -PropertyType String -Force
