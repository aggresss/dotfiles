<# 
 # File: Microsoft.PowerShell_profile.ps1
 # URL: https://raw.githubusercontent.com/aggresss/dotfiles/master/PowerShell/Microsoft.PowerShell_profile.ps1
 # Before inport this ps1 file, you need run these command:
 #     New-Item -Path "$profile" -ItemType "file" -Force
 #     Set-ExecutionPolicy RemoteSigned
 #>

<# PoSH for Common #>
set-alias vim "${Env:ProgramFiles(x86)}\Vim\vim82\vim.exe"

function code {
    $code_path="${Env:LOCALAPPDATA}\Programs\Microsoft VS Code\Code.exe"
    if($args.Count -eq 0) {
        Start-Process -Wait -FilePath $code_path
    } else {
        Start-Process -Wait -FilePath $code_path -ArgumentList "$args"
    }
}

function touch {New-Item "$args" -ItemType File}
Set-Alias grep Select-String

function s {set-location ${env:USERPROFILE}\workspace-scratch}

<# PoSH for Git #>

<# PoSH for Golang #>
function go_pwd {$Env:GOPATH="${PWD}"}

<# PoSH for Visual Studio #>
function vs_env {
    $vs_path = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community\Common7\Tools"
    Push-Location $vs_path
    cmd /c "VsDevCmd.bat & set" |
        ForEach-Object {
            if ($_ -match "=") {
                $v = $_.split("=")
                Set-Item -Force -Path "Env:\$($v[0])" -Value "$($v[1])"
        }
    }
    Pop-Location
    Write-Host "`nVisual Studio Command Prompt variables set." -ForegroundColor Yellow
}

