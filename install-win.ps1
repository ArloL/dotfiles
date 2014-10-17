if (Test-Path $PROFILE) {
    $file = Get-Item $PROFILE -Force -ea 0
    $symlink = $file.Attributes -band [IO.FileAttributes]::ReparsePoint
    if (-Not $symlink) {
        Remove-Item $PROFILE
        cmd /c mklink "$PROFILE" "$($args[0])"
    }
} else {
    cmd /c mklink "$PROFILE" "$($args[0])"
}

. $PROFILE

iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
scoop install concfg
concfg import -n solarized-light small concfg\source-code-pro.json
concfg clean
