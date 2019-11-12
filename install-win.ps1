$profileDotSource = '. C:\Users\okeeffea\dotfiles\Microsoft.PowerShell_profile.ps1'

if (Test-Path $PROFILE) {
    $textInProfile = Select-String -Quiet -Pattern "$profileDotSource" -SimpleMatch -Path $PROFILE
    if (-not $textInProfile) {
        Add-Content -Path $PROFILE -Value "`r`n$profileDotSource"
    }
} else {
    New-Item -Path $PROFILE -ItemType "file" -Value "$profileDotSource" -Force
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

if (-Not (Get-Module -ListAvailable -Name PSReadline)) {
    Install-Module PSReadline
}
