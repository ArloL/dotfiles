$code32 = ${Env:ProgramFiles(x86)} + "\Microsoft VS Code\code.exe"
$code64 = ${Env:ProgramFiles} + "\Microsoft VS Code\code.exe"
$sublime = ${Env:ProgramFiles} + "\Sublime Text 3\sublime_text.exe"
$atom = ${Env:LocalAppData} + "\atom\app-1.4.0\atom.exe"

if (Test-Path $code64) {
    $editor = '"%PROGRAMFILES%\Microsoft VS Code\code.exe" "%1"'
} elseif (Test-Path $code32) {
    $editor = '"%PROGRAMFILES(X86)%\Microsoft VS Code\code.exe" "%1"'
} elseif (Test-Path $sublime) {
    $editor = '"%PROGRAMFILES%\Sublime Text 3\sublime_text.exe" "%1"'
} elseif (Test-Path $atom) {
    $editor = '"%LOCALAPPDATA%\atom\app-1.4.0\atom.exe" "%1"'
} else {
    echo "No supported editor installed."
    exit 0
}

$classesRegistryRoot = "HKCU:\Software\Classes"
$systemFileAssociationsRegistryRoot = $classesRegistryRoot + "\SystemFileAssociations"
$applicationsRegistryRoot = $classesRegistryRoot + "\Applications"
$registrySuffix = "shell\edit\command"

$classes = "batfile", "cmdfile", "regfile", "txtfile", "Microsoft.PowerShellScript.1"
$systemFileAssociations = ".css", ".htm", ".html", ".js", ".ps1", ".reg", ".sh", "text", ".xhtml"
$applications = "NOTEPAD.EXE"

foreach($item in $classes) {
    New-Item -Path $classesRegistryRoot\$item\$registrySuffix -Value $editor -ItemType ExpandString -Force
}

foreach($item in $systemFileAssociations) {
    New-Item -Path $systemFileAssociationsRegistryRoot\$item\$registrySuffix -Value $editor -ItemType ExpandString -Force
}

foreach($item in $applications) {
    New-Item -Path $applicationsRegistryRoot\$item\$registrySuffix -Value $editor -ItemType ExpandString -Force
}
