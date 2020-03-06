<#
 # File: Microsoft.PowerShell_profile.ps1
 # URL: https://raw.githubusercontent.com/aggresss/dotfiles/master/PowerShell/Microsoft.PowerShell_profile.ps1
 # Before import this ps1 file, you need run these command:
 #     New-Item -Path "$profile" -ItemType "file" -Force
 #     Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
 #     Install-Module posh-git -Scope CurrentUser -Force
 #     Set-Service -Name ssh-agent -StartupType automatic
 #>

<########################
 # PoSH for Common
 ########################>

# short for cd ..
function .. {Set-Location ..}
function ... {Set-Location ../..}
function .... {Set-Location ../../../}
function ..... {Set-Location ../../../../}

Set-Alias grep Select-String

function u {. $profile}
function touch {New-Item "$args" -ItemType File}

Set-Alias vim "${Env:ProgramFiles(x86)}\Vim\vim82\vim.exe"
Set-Alias code "${Env:LOCALAPPDATA}\Programs\Microsoft VS Code\Code.exe"

function cd_scratch {
    $s_path = "${env:USERPROFILE}\workspace-scratch"
    if (-not $(Test-Path $s_path)) {
        New-Item $s_path -ItemType directory -Force
    }
    Set-Location $s_path
}
Set-Alias s cd_scratch

function cd_formal {
    $f_path = "${env:USERPROFILE}\workspace-formal"
    if (-not $(Test-Path $f_path)) {
        New-Item $f_path -ItemType directory -Force
    }
    Set-Location $f_path
}
Set-Alias f cd_formal

function cd_documents {
    $doc_path = "${env:USERPROFILE}\Documents"
    if (-not $(Test-Path $doc_path)) {
        New-Item $doc_path -ItemType directory -Force
    }
    Set-Location $doc_path
}
Set-Alias m cd_documents

function cd_downloads {
    $down_path = "${env:USERPROFILE}\Downloads"
    if (-not $(Test-Path $down_path)) {
        New-Item $down_path -ItemType directory -Force
    }
    Set-Location $down_path
}
Set-Alias d cd_downloads

# SSH
function ssh_agent_add {
    ssh-agent.exe
    ssh-add.exe -l
    if (-not $?) {
        ssh-add.exe
    }
}
Set-Alias a ssh_agent_add

function ssh_agent_del {
    ssh-add.exe -d
}
Set-Alias k ssh_agent_del

# source_file
# args[0] run/copy/edit
# args[1] file
# args[2..-1] lines
function source_file {
    $note_dir = "${env:USERPROFILE}\note\"
    function add_index {
        Begin { $i = 1}
        Process {
            $_ | Add-Member -NotePropertyName "Index" -NotePropertyValue $i
            $i++
        }
        End {}
    }
    function number_line{
        Get-content $args | Out-String -Stream | Select-String '.*' | Select-Object LineNumber, Line
    }

    if ($args.Count -eq 0) {
        Write-Host "Arguments error."
    } elseif ($args.Count -eq 1) {
        $file_index = Get-ChildItem -Path $note_dir -Exclude .*
        $file_index | add_index
        $file_index | Format-Table -Property Index,Name -AutoSize
    } else {
        $filepath = ""
        $file_index = Get-ChildItem -Path $note_dir -Exclude .*
        $file_index | add_index
        if (($args[1] -match '^[0-9]+$') -and ($args[1] -gt $file_index.Count)) {
            Write-Host "File index out of range."
            return
        }
        if (($args[1] -match '^[0-9]+$') -and ($args[1] -le $file_index.Count)) {
            $index = $args[1]
            $filename = $file_index | Where-Object {$_.Index -eq $index}
            $filepath = $note_dir + $filename.Name.ToString()
        } else {
            $filepath = $args[1]
        }
        if ( ($args.Count -eq 2) -or (($args.Count -ge 2) -and ($args[0] -eq "edit")) ) {
            if ($args[0] -eq "edit") {
                vim $filepath
            } else {
                number_line $filepath
            }
            return
        }
        if (-not $(Test-Path $filepath)) {
            Write-Host "File not exist." -ForegroundColor Red
            return
        }
        # Process index of spesical file
        $ReadyCacheArray = @()
        $file_cache = Get-Content -Path $filepath
        for ($k = 2; $k -lt $args.Count; $k++) {
            if ($args[$k] -eq "all") {
                for($j = 0; $j -lt $file_cache.Count; $j++) {
                    $data = [ordered]@{LineNumber=$j + 1;Content=$file_cache[$j].ToString()}
                    $ReadyCacheArray += New-Object -TypeName PSCustomObject -Property $data
                }
            } elseif (($args[$k] -match '^[0-9]+$') -and ($args[$k] -le $file_cache.Count)) {
                $data = [ordered]@{LineNumber=$args[$k];Content=$file_cache[$args[$k] - 1].ToString()}
                $ReadyCacheArray += New-Object -TypeName PSCustomObject -Property $data
            } elseif ($args[$k] -match '-') {
                $from = $args[$k].split('-', 2)[0]
                $to = $args[$k].split('-', 2)[1]
                if (($from -match '^[0-9]+$') -and ($to -match '^[0-9]+$') -and ($from -le $file_cache.Count) -and ($to -le $file_cache.Count)) {
                    $range = $from..$to
                    foreach ($item in $range) {
                        $data = [ordered]@{LineNumber=$item;Content=$file_cache[$item - 1].ToString()}
                        $ReadyCacheArray += New-Object -TypeName PSCustomObject -Property $data
                    }
                }
            }
        }
        # Process Action
        if ($ReadyCacheArray.Count -eq 0) {
            return
        } else {
            $ReadyCacheArray
        }
        if ($args[0] -eq "copy") {
            $output_clipboard = @()
            foreach ($str in $ReadyCacheArray) {
                $output_clipboard += $str.Content.ToString()
            }
            Set-Clipboard $output_clipboard
        } elseif ($args[0] -eq "exec") {
            $output_exec = ""
            foreach ($str in $ReadyCacheArray) {
                $output_exec += $str.Content.ToString()
                $output_exec += ";"
            }
            $output_exec | Invoke-Expression
        }
    }
}
function source_file_exec {
    $run_script="source_file exec"
    foreach($a in $args){
        $run_script += " $a"
    }
    $run_script | Invoke-Expression
}
Set-Alias x source_file_exec
function source_file_copy {
    $run_script="source_file copy"
    foreach($a in $args){
        $run_script += " $a"
    }
    $run_script | Invoke-Expression
}
Set-Alias c source_file_copy

function source_file_edit {
    $run_script="source_file edit"
    foreach($a in $args){
        $run_script += " $a"
    }
    $run_script | Invoke-Expression
}
Set-Alias e source_file_edit

<########################
 # PoSH for Git
 ########################>

function git_prompt {
    if (-not (get-module | Where-Object {$_.Name -eq "posh-git"})) {
        Import-Module -Name posh-git -Scope Global
    } else {
        $GitPromptSettings.EnablePromptStatus = -not $GitPromptSettings.EnablePromptStatus
    }
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

function git_branch {
    git branch -vv $args
}
Set-Alias b git_branch

function git_clone {
    $clone_path = $args[0]
    if ($clone_path -match "@") {
        $clone_path = $clone_path.split("@")[1]
        $clone_path = $clone_path.replace(":", "/")
    } elseif ($clone_path -match "://") {
        $clone_path = $clone_path.split("/", 3)[2]
    } else {
        Write-Host "Arguments error."
        return
    }
    # strip suffix
    $clone_path = $clone_path.replace(".git", "")

    Write-Host Clone on $clone_path
    git clone $args $clone_path
}

<########################
 # PoSH for Golang
 ########################>

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

function go_clone {
    $clone_path = $args[0]
    if ($clone_path -match "@") {
        $clone_path = $clone_path.split("@")[1]
        $clone_path = $clone_path.replace(":", "/")
    } elseif ($clone_path -match "://") {
        $clone_path = $clone_path.split("/", 3)[2]
    } else {
        Write-Host "Arguments error."
        return
    }
    # strip suffix
    $clone_path = $clone_path.replace(".git", "")
    $repo_name = $clone_path.split("/")[-1]

    Write-Host Clone on $repo_name/src/$clone_path
    git clone $args $repo_name/src/$clone_path
}

<########################
 # PoSH for Visual Studio
 ########################>

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

<########################
 # Echo Envronment
 ########################>

Write-Host "ENV:" (Get-WmiObject Win32_OperatingSystem).Caption -ForegroundColor DarkGreen
Write-Host "PowerShell Version:" ${PSVersionTable}.PSVersion.ToString() -ForegroundColor DarkGreen
