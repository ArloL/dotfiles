param(
  [bool]$Clear = $false
)

$Startmenu = [Environment]::GetFolderPath("Startmenu")

New-Item -ItemType Directory -Force -Path "$Startmenu\Programs\Eclipse\" | Out-Null

IF ($Clear -eq $true) {
  Get-ChildItem -Path "$Startmenu\Programs\Eclipse\" -Include *.lnk -File -Recurse | foreach { $_.Delete()}
}

$EclipseExes = gci -recurse -filter "eclipse.exe" -File

$WScriptShell = New-Object -ComObject WScript.Shell

foreach ($EclipseExe in $EclipseExes) {

    $ProjectDirectory = $EclipseExe.Directory.Parent

    $ShortcutFile = "$Startmenu\Programs\Eclipse\$ProjectDirectory.lnk"

    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $EclipseExe.FullName
    $Shortcut.WorkingDirectory = $EclipseExe.Directory.FullName
    $Shortcut.Save()

}
