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
concfg import -n solarized-light concfg\source-code-pro.json
concfg clean

if (-Not (Get-Command 'choco' -errorAction SilentlyContinue)) {
    Invoke-Expression (new-object net.webclient).downloadstring('https://chocolatey.org/install.ps1')
}

choco feature enable -n allowGlobalConfirmation
choco upgrade chocolatey
choco install curl wget 7zip sudo
choco upgrade all

$elevate = ${Env:UserProfile} + "\bin\elevate.exe"
if (-Not (Test-Path $elevate)) {
    Invoke-WebRequest -Uri http://code.kliu.org/misc/elevate/elevate-1.3.0-redist.7z -OutFile elevate.7z
    7z x elevate.7z -y -oelevate
    Move-Item -Force elevate/bin.x86-64/elevate.exe $elevate
    Remove-Item elevate.7z
    Remove-Item -Force -Recurse elevate
}

Install-Module PSReadline -Force
