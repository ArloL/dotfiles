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

if (-Not (Get-Command 'scoop' -errorAction SilentlyContinue)) {
    Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')
}

scoop update
scoop install concfg
scoop update concfg
concfg import -n solarized-light small concfg\source-code-pro.json
concfg clean

if (-Not (Get-Command 'choco' -errorAction SilentlyContinue)) {
    Invoke-Expression (new-object net.webclient).downloadstring('https://chocolatey.org/install.ps1')
}

choco feature enable -n allowGlobalConfirmation
choco upgrade chocolatey
choco install curl wget 7zip
choco upgrade all

Install-Module PSReadline
