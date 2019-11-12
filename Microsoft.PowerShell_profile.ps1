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

if (Get-Command "code" -ErrorAction SilentlyContinue) {
    function edit {
        Start-Process code -WindowStyle Minimized $args
    }
} elseif (Get-Command "atom" -ErrorAction SilentlyContinue) {
    Set-Alias edit atom
} elseif (Test-Path 'C:\Program Files\Sublime Text 3') {
    Set-Alias edit 'C:\Program Files\Sublime Text 3\sublime_text'
}

[net.webrequest]::defaultwebproxy.credentials = [net.credentialcache]::defaultcredentials

if (Get-Command Import-Module -ErrorAction SilentlyContinue) {
    Import-Module PSReadLine

    Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

    $PSReadLineOptions = @{
        HistoryNoDuplicates = $true
        AddToHistoryHandler = {
            param($line)
            if ($line -eq 'exit') {
                return $false
            }
            $true
        }
    }
    Set-PSReadLineOption @PSReadLineOptions

    $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    if (Test-Path($ChocolateyProfile)) {
        Import-Module "$ChocolateyProfile"
    }

}
