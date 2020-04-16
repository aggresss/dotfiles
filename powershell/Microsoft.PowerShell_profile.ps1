<#
 # File: Microsoft.PowerShell_profile.ps1
 # URL: https://raw.githubusercontent.com/aggresss/dotfiles/master/PowerShell/Microsoft.PowerShell_profile.ps1
 # Before import this ps1 file, you need run these command:
 #     Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
 #>

<########################
 # PoSH for Common
 ########################>

# short for cd ..
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../../ }
function ..... { Set-Location ../../../../ }

function u { . $profile }
function ll {
  if ((Get-Command ls).CommandType -eq "Application") {
    ls -al
  }
  else {
    Get-ChildItem -Attributes !System, Hidden
  }
}

function internal_env_opration {
  Param (
    [parameter(Mandatory = $true)] [bool]$is_insert,
    [parameter(Mandatory = $true)] [string]$env_name,
    [parameter(Mandatory = $true)] [String]$env_value
  )
  if ($IsWindows -or $Env:OS) { $separator = ';' } else { $separator = ':' }

  ('$curr_values = $env:{0}' -f $env_name) | Invoke-Expression
  if ((-not $curr_values) -or ($curr_values -eq "")) {
    ('$Env:{0} = "$env_value"' -f $env_name) | Invoke-Expression
  }
  else {
    if ($curr_values -like "*$separator*") {
      $values_array = $curr_values.split("$separator")
      foreach ($value in $values_array) {
        if ($value -eq $env_value) {
          return
        }
      }
    }
    else {
      if ($curr_values -eq $env_value) {
        return
      }
    }
    if ($is_insert) {
      $eval = '$Env:{0} = "$env_value$separator$Env:{0}"'
    }
    else {
      $eval = '$Env:{0} += "$separator$env_value"'
    }
    ($eval -f $env_name) | Invoke-Expression
  }
}

function env_insert {
  Param (
    [parameter(Mandatory = $true)] [string]$env_name,
    [parameter(Mandatory = $true)] [String]$env_value
  )
  internal_env_opration $true $env_name $env_value
}

function env_append {
  Param (
    [parameter(Mandatory = $true)] [string]$env_name,
    [parameter(Mandatory = $true)] [String]$env_value
  )
  internal_env_opration $false $env_name $env_value
}

function env_prune {
  Param (
    [parameter(Mandatory = $true)] [string]$env_name,
    [parameter(Mandatory = $true)] [String]$env_value
  )
  if ($IsWindows -or $Env:OS) { $separator = ';' } else { $separator = ':' }

  ('$curr_values = $env:{0}' -f $env_name) | Invoke-Expression
  if ((-not $curr_values) -or ($curr_values -eq "")) {
    return
  }
  else {
    if ($curr_values -like "*$separator*") {
      $values_array = $curr_values.split("$separator")
      foreach ($value in $values_array) {
        if (-not ($value -eq $env_value)) {
          if (-not $new_value) {
            $new_value = "$value"
          }
          else {
            $new_value += "$separator$value"
          }
        }
      }
      ('$Env:{0} = "$new_value"' -f $env_name) | Invoke-Expression
    }
    else {
      if ($curr_values -eq $env_value) {
        ('$Env:{0} = ""' -f $env_name) | Invoke-Expression
      }
    }
  }
}

function env_amend {
  Param (
    [parameter(Mandatory = $true)] [string]$env_name,
    [parameter(Mandatory = $true)] [String]$env_value
  )
  ('$Env:{0} = "$env_value"' -f $env_name) | Invoke-Expression
}

function env_print {
  Param (
    [parameter(Mandatory = $true)] [string]$env_name
  )
  if ($IsWindows -or $Env:OS) { $separator = ';' } else { $separator = ':' }

  ('$curr_values = $env:{0}' -f $env_name) | Invoke-Expression
  if (($curr_values) -and (-not $curr_values -eq "")) {
    Write-Host "${env_name}:" -ForegroundColor DarkRed
    if ($curr_values -like "*$separator*") {
      $values_array = $curr_values.split("$separator")
      foreach ($value in $values_array) {
        Write-Host "$value" -ForegroundColor DarkGreen
      }
    }
    else {
      Write-Host "$curr_values" -ForegroundColor DarkGreen
    }
  }
}

function env_unset {
  Param (
    [parameter(Mandatory = $true)] [string]$env_name
  )
  ('Remove-Item Env:\{0}' -f $env_name) | Invoke-Expression
}

function cd_scratch {
  $s_path = "${HOME}/workspace-scratch"
  if (-not $(Test-Path $s_path)) {
    New-Item $s_path -ItemType directory -Force
  }
  Set-Location $s_path
}
Set-Alias s cd_scratch

function cd_formal {
  $f_path = "${HOME}/workspace-formal"
  if (-not $(Test-Path $f_path)) {
    New-Item $f_path -ItemType directory -Force
  }
  Set-Location $f_path
}
Set-Alias f cd_formal

function cd_documents {
  $doc_path = "${HOME}/Documents"
  if (-not $(Test-Path $doc_path)) {
    New-Item $doc_path -ItemType directory -Force
  }
  Set-Location $doc_path
}
Set-Alias m cd_documents

function cd_downloads {
  $down_path = "${HOME}/Downloads"
  if (-not $(Test-Path $down_path)) {
    New-Item $down_path -ItemType directory -Force
  }
  Set-Location $down_path
}
Set-Alias d cd_downloads

# SSH
function ssh_agent_add {
  ssh-agent
  ssh-add -l
  if (-not $?) {
    ssh-add
  }
}
Set-Alias a ssh_agent_add

function ssh_agent_del {
  ssh-add -d
}
Set-Alias k ssh_agent_del

# source_file
# args[0] exec/copy/edit
# args[1] file
# args[2..-1] lines
function source_file {
  $note_dir = "${HOME}/note/"
  function add_index {
    Begin { $i = 1 }
    Process {
      $_ | Add-Member -NotePropertyName "Index" -NotePropertyValue $i
      $i++
    }
    End { }
  }
  function number_line {
    Get-content $args | Out-String -Stream | Select-String '.*' | Select-Object LineNumber, Line
  }

  if ($args.Count -eq 0) {
    Write-Host "Arguments error."
  }
  elseif ($args.Count -eq 1) {
    if (-not $(Test-Path $note_dir)) {
      New-Item -Path $note_dir -ItemType Directory
      New-Item -Path ${note_dir}/note.common -ItemType File
    }
    $file_index = Get-ChildItem -Path $note_dir -Exclude .*
    $file_index | add_index
    $file_index | Format-Table -Property Index, Name -AutoSize
  }
  else {
    $filepath = ""
    $file_index = Get-ChildItem -Path $note_dir -Exclude .*
    $file_index | add_index
    if (($args[1] -match '^[0-9]+$') -and ($args[1] -gt $file_index.Count)) {
      Write-Host "File index out of range."
      return
    }
    if (($args[1] -match '^[0-9]+$') -and ($args[1] -le $file_index.Count)) {
      $index = $args[1]
      $filename = $file_index | Where-Object { $_.Index -eq $index }
      $filepath = $note_dir + $filename.Name.ToString()
    }
    else {
      $filepath = $args[1]
    }
    if ( ($args.Count -eq 2) -or (($args.Count -ge 2) -and ($args[0] -eq "edit")) ) {
      if ($args[0] -eq "edit") {
        vim $filepath
      }
      else {
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
        for ($j = 0; $j -lt $file_cache.Count; $j++) {
          $data = [ordered]@{LineNumber = $j + 1; Content = $file_cache[$j].ToString() }
          $ReadyCacheArray += New-Object -TypeName PSCustomObject -Property $data
        }
      }
      elseif ($args[$k] -match '-') {
        $from = $args[$k].split('-', 2)[0]
        $to = $args[$k].split('-', 2)[1]
        if (($from -match '^[0-9]+$') -and ($to -match '^[0-9]+$')) {
          $range = $from..$to
          foreach ($item in $range) {
            $data = [ordered]@{LineNumber = $item; Content = $file_cache[$item - 1].ToString() }
            $ReadyCacheArray += New-Object -TypeName PSCustomObject -Property $data
          }
        }
      }
      elseif (($args[$k] -match '^[0-9]+$') -and ($args[$k] -le $file_cache.Count)) {
        $data = [ordered]@{LineNumber = $args[$k]; Content = $file_cache[$args[$k] - 1].ToString() }
        $ReadyCacheArray += New-Object -TypeName PSCustomObject -Property $data
      }
    }
    # Process Action
    if ($ReadyCacheArray.Count -eq 0) {
      return
    }
    else {
      $ReadyCacheArray
    }
    if ($args[0] -eq "copy") {
      $output_clipboard = @()
      foreach ($str in $ReadyCacheArray) {
        $output_clipboard += $str.Content.ToString()
      }
      Set-Clipboard $output_clipboard
    }
    elseif ($args[0] -eq "exec") {
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
  $run_script = "source_file exec"
  foreach ($a in $args) {
    $run_script += " $a"
  }
  $run_script | Invoke-Expression
}
Set-Alias x source_file_exec
function source_file_copy {
  $run_script = "source_file copy"
  foreach ($a in $args) {
    $run_script += " $a"
  }
  $run_script | Invoke-Expression
}
Set-Alias c source_file_copy

function source_file_edit {
  $run_script = "source_file edit"
  foreach ($a in $args) {
    $run_script += " $a"
  }
  $run_script | Invoke-Expression
}
Set-Alias e source_file_edit

<########################
 # PoSH for Git
 ########################>

function git_prompt {
  if (-not $(Get-InstalledModule -Name "posh-git")) {
    Install-Module posh-git -Scope CurrentUser -Force
  }
  if (-not (Get-Module -Name "posh-git")) {
    Import-Module -Name posh-git -Scope Global
  }
  else {
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
  }
  elseif ($args -eq "rebase") {
    git fetch origin
    git rebase origin/${branch}
  }
  else {
    git commit -m $(get-date -uformat "%Y-%m-%d %T %Z W%WD%u")
    git push origin ${branch}:${branch}
  }
}

function git_sig {
  if ($args.Count -eq 0) {
    Write-Host "user.name: $(git config --get user.name)"
    Write-Host "user.email: $(git config --get user.email)"
  }
  elseif ($args -match "@") {
    $v = $args.split("@")
    git config user.name $v[0]
    git config user.email $args
  }
  else {
    Write-Host "Arguments error."
  }
}

# Get pull request to local branch
# $1 remote name
# $2 pull request index No.
function git_pull {
  if ($args.Count -lt 2 ) {
    Write-Host "Arguments error."
    return
  }
  $remote_name = $args[0]
  $remote_pr = $args[1]
  $ErrorActionPreference = "stop"; `
    git fetch ${remote_name} pull/${remote_pr}/head:pull/${remote_name}/${remote_pr}; `
    git checkout pull/${remote_name}/${remote_pr}
}

function git_log {
  git log --oneline
}

function git_diff {
  git diff --name-status
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
  }
  elseif ($clone_path -match "://") {
    $clone_path = $clone_path.split("/", 3)[2]
  }
  else {
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

if (-not $GOPATH_BAK) {
  $GOPATH_BAK = ${env:GOPATH}
}

# reset $GOPATH
function go_reset() {
  ${env:GOPATH} = ${GOPATH_BAK}
  Write-Host "Successful clear GOPATH: ${env:GOPATH}"
}
function go_pwd { env_amend GOPATH "${PWD}" }

function go_path { env_print GOPATH }
Set-Alias g go_path

function go_clone {
  $clone_path = $args[0]
  if ($clone_path -match "@") {
    $clone_path = $clone_path.split("@")[1]
    $clone_path = $clone_path.replace(":", "/")
  }
  elseif ($clone_path -match "://") {
    $clone_path = $clone_path.split("/", 3)[2]
  }
  else {
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
 # Update
 ########################>

function update_internal {
  Param (
    [parameter(Mandatory = $true)] [bool]$IsLocal,
    [parameter(Mandatory = $true)] [String]$Remote,
    [parameter(Mandatory = $true)] [String]$Local
  )
  $local_base_path = "${HOME}/workspace-scratch/dotfiles"
  $remote_base_url = "https://raw.githubusercontent.com/aggresss/dotfiles/master"
  if ($IsLocal -and ($(Test-Path $local_base_path))) {
    $ErrorActionPreference = "stop"; `
      Copy-Item "${local_base_path}/$Remote" "$Local"; `
      Write-Host "Local update $Local successful." -ForegroundColor DarkGreen
  }
  else {
    $ErrorActionPreference = "stop"; `
      Invoke-WebRequest -Uri "${remote_base_url}/$Remote" -OutFile "$Local"; `
      Write-Host "Remote update $Local successful." -ForegroundColor DarkGreen
  }
}
function update_config_self {
  if ($args[0] -eq "local") {
    update_internal $true "powershell/Microsoft.PowerShell_profile.ps1" $PROFILE
  }
  else {
    update_internal $false "powershell/Microsoft.PowerShell_profile.ps1" $PROFILE
  }
}

function update_config_vim {
  if ($args[0] -eq "local") {
    update_internal $true "vim/.vimrc" "${HOME}/.vimrc"
    update_internal $true "vim/.vimrc.bundles" "${HOME}/.vimrc.bundles"
  }
  else {
    update_internal $false "vim/.vimrc" "${HOME}/.vimrc"
    update_internal $false "vim/.vimrc.bundles" "${HOME}/.vimrc.bundles"
  }
  if (-not $(Test-Path ${HOME}/.vim/bundle)) {
    $ErrorActionPreference = "stop"; `
      git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim; `
      vim +BundleInstall +qall
  }
  else {
    vim +BundleInstall +qall
  }
}

<########################
 # Envronment specific
 ########################>
if ($IsWindows -or $Env:OS) {
  function touch { New-Item "$args" -ItemType File }
  
  function vs_env {
    $vs_path = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community\Common7\Tools"
    if (-not $(Test-Path $vs_path)) {
      return
    }
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

  Set-Alias grep Select-String
  $vim_path = "${Env:ProgramFiles(x86)}\Vim\vim82\vim.exe"
  if ($(Test-Path $vim_path)) {
    Set-Alias vim $vim_path
  }
  $code_path = "${Env:LOCALAPPDATA}\Programs\Microsoft VS Code\Code.exe"
  if ($(Test-Path $code_path)) {
    Set-Alias code $code_path
  }

}
elseif ($(uname) -eq "Darwin") {
  # use "brew install gnu-*" instead of bsd-*
  Set-Alias -Name sed -Value gsed
  Set-Alias -Name awk -Value gawk
  Set-Alias -Name tar -Value gtar
  Set-Alias -Name find -Value gfind
  # open application from command
  function calc { open -a Calculator $args }
  function typora { open -a Typora $args }
  function diffmerge { open -a DiffMerge $args }
  function code { open -a "Visual Studio Code" $args }
  function vlc { open -a VLC $args }
  function skim { open -a Skim $args }
  function drawio { open -a draw.io $args }
  function chrome { open -a "Google Chrome" $args }
  function note { open -a YoudaoNote $args }
  function dict { open -a "网易有道词典" $args }
  function mail { open -a Foxmail $args }

}
elseif ($(uname) -eq "Linux") {
  function hello { Write-Host "hello" }
}


<########################
 # Echo Envronment
 ########################>
Write-Host ($PSVersionTable).OS -ForegroundColor DarkGreen
Write-Host "PowerShell Version:" ${PSVersionTable}.PSVersion.ToString() -ForegroundColor DarkCyan
