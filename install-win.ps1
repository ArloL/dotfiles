if (Test-Path $PROFILE) {
    $file = Get-Item $PROFILE -Force -ea 0
    $symlink = $file.Attributes -band [IO.FileAttributes]::ReparsePoint
    if (-Not $symlink) {
        Remove-Item $PROFILE
        cmd /c mklink "$PROFILE" "$($args[0])"
    }
} else {
    $profilePath = Split-Path $PROFILE
    if (!(Test-Path -Path $profilePath)) {
        New-Item -ItemType directory -Path $profilePath | Out-Null
    }
    cmd /c mklink "$PROFILE" "$($args[0])"
}

. $PROFILE

iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
scoop update
scoop install concfg curl wget 7zip
scoop update concfg curl wget 7zip
concfg import -n solarized-light small concfg\source-code-pro.json
concfg clean

Install-Module PSReadline
