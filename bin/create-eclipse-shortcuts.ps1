New-Item -ItemType Directory -Force -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Eclipse\" | Out-Null

$EclipseExes = gci -recurse -filter "eclipse.exe" -File

$WScriptShell = New-Object -ComObject WScript.Shell

foreach ($EclipseExe in $EclipseExes) {

    $ProjectDirectory = $EclipseExe.Directory.Parent

    $ShortcutFile = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Eclipse\$ProjectDirectory.lnk"

    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $EclipseExe.FullName
    $Shortcut.WorkingDirectory = $EclipseExe.Directory.FullName 
    $Shortcut.Save()

}
