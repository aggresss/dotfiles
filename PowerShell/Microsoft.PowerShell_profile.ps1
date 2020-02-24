<#
 # File: Microsoft.PowerShell_profile.ps1
 # URL: https://raw.githubusercontent.com/aggresss/dotfiles/master/PowerShell/Microsoft.PowerShell_profile.ps1
 # Before import this ps1 file, you need run these command:
 #     New-Item -Path "$profile" -ItemType "file" -Force
 #     Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
 #>

<# PoSH for Common #>
Import-Module posh-git

$GitPromptSettings.EnablePromptStatus = $false

Set-Alias grep Select-String
function touch {New-Item "$args" -ItemType File}

Set-Alias vim "${Env:ProgramFiles(x86)}\Vim\vim82\vim.exe"
function code {
    $code_path="${Env:LOCALAPPDATA}\Programs\Microsoft VS Code\Code.exe"
    if ($args.Count -eq 0) {
        Start-Process -FilePath $code_path
    } else {
        Start-Process -FilePath $code_path -ArgumentList "$args"
    }
}

function s {set-location ${env:USERPROFILE}\workspace-scratch}

<# PoSH for Git #>

function git_prompt {
        $GitPromptSettings.EnablePromptStatus = -not $GitPromptSettings.EnablePromptStatus
}
Set-Alias p git_prompt

function git_status {
    git status
    git stash list
}
Set-Alias y git_status

function git_top {
    git rev-parse --show-toplevel | Set-Location
}
Set-Alias t git_top

function git_haste {
    $branch = Get-GitBranch
    if (-not $branch) {
        Write-Host "Not a git repository"
        return
    }
    if ($args -eq "commit") {
        git commit -m $(get-date -uformat "%Y-%m-%d %T %Z W%WD%u")
    } elseif ($args -eq "rebase") {
        git fetch origin
        git rebase origin/${branch}
    } else {
        git commit -m $(get-date -uformat "%Y-%m-%d %T %Z W%WD%u")
        git push origin ${branch}:${branch}
    }
}

function git_sig {
    if ($args.Count -eq 0) {
        Write-Host "user.name: $(git config --get user.name)"
        Write-Host "user.email: $(git config --get user.email)"
    } elseif ($args -match "@") {
        $v = $args.split("@")
        git config user.name $v[0]
        git config user.email $args
    } else {
        Write-Host "Arguments error."
    }
}

function git_log {
    git log --oneline
}

<# PoSH for Golang #>

$GOPATH_BAK = ${env:GOPATH}
# reset $GOPATH
function go_reset()
{
    ${env:GOPATH} = ${GOPATH_BAK}
    Write-Host "Successful clear GOPATH: ${env:GOPATH}"
}
function go_pwd {$Env:GOPATH="${PWD}"}

function go_path {
    Write-Host "GOPATH: ${env:GOPATH}" -ForegroundColor DarkGreen
}
Set-Alias g go_path

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

<# Echo Envronment #>
Write-Host "ENV:" (Get-WmiObject Win32_OperatingSystem).Caption -ForegroundColor DarkGreen
Write-Host "PowerShell Version:" ${PSVersionTable}.PSVersion.ToString() -ForegroundColor DarkGreen
