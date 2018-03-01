$Startmenu = [Environment]::GetFolderPath("Startmenu")

New-Item -ItemType Directory -Force -Path "$Startmenu\Programs\Eclipse\" | Out-Null

$WScriptShell = New-Object -ComObject WScript.Shell

$EclipseShortcuts = Get-ChildItem -Recurse -Path "$Startmenu\Programs\Eclipse\" -Include *.lnk -File

foreach ($EclipseShortcut in $EclipseShortcuts) {
    $Shortcut = $WScriptShell.CreateShortcut($EclipseShortcut)
    if (!(Test-Path $Shortcut.TargetPath)) {
        Remove-Item -Force -Path $EclipseShortcut
    }
}

$EclipseExes = Get-ChildItem -Recurse -filter "eclipse.exe" -File | ?{ $_.fullname -notmatch "\\backup\\?" }

foreach ($EclipseExe in $EclipseExes) {

    $ProjectDirectory = $EclipseExe.Directory.Parent

    $ShortcutFile = "$Startmenu\Programs\Eclipse\$ProjectDirectory.lnk"

    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $EclipseExe.FullName
    $Shortcut.WorkingDirectory = $EclipseExe.Directory.FullName
    $Shortcut.Save()

}
