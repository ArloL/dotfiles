chcp 65001 | out-null

function prompt {
    '[' + $env:username + '@' + $env:computername + ' ' + $pwd + "]`r`n$ "
}

function .. {
    Set-Location ..
}
function ... {
    Set-Location ..\..
}
function .... {
    Set-Location ..\..\..
}

Set-Alias l Get-ChildItem
Set-Alias ll Get-ChildItem
Set-Alias open Invoke-Item

if (Test-Path "C:\Program Files\Sublime Text 3") {
    Set-Alias edit "C:\Program Files\Sublime Text 3\sublime_text"
}

[net.webrequest]::defaultwebproxy.credentials = [net.credentialcache]::defaultcredentials