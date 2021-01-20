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

  ('$curr_values = $Env:{0}' -f $env_name) | Invoke-Expression
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

  ('$curr_values = $Env:{0}' -f $env_name) | Invoke-Expression
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

  ('$curr_values = $Env:{0}' -f $env_name) | Invoke-Expression
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

function code_user {
  if ($IsWindows -or $Env:OS) {
    Set-Location ${Env:APPDATA}/Code/User
  }
  elseif ($(uname) -eq "Darwin") {
    Set-Location ${HOME}/Library/Application Support/Code/User
  }
  elseif ($(uname) -eq "Linux") {
    Set-Location ${HOME}/.config/Code/User
  }
}

# SSH

function ssh_agent_env {
  Param (
    [parameter(Mandatory = $false)] [String]$ssh_agent_config
  )
  if ((-not $ssh_agent_config) -and (Test-Path ${HOME}/.ssh-agent.conf)) {
    $ssh_agent_config = Get-Content -Path ${HOME}/.ssh-agent.conf
  }
  $lines = $ssh_agent_config.Split(";")
  foreach ($line in $lines) {
    if (([string]$line).Trim() -match "(.+)=(.*)") {
      [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
    }
  }
}

# ssh-add -l > $null 2>&1
# $LastExitCode=0 means the socket is there and it has a key
# $LastExitCode=1 means the socket is there but contains no key
# $LastExitCode=2 means the socket is not there or broken
function ssh_agent_check {
  ssh-add -l > $null 2>&1; $ssh_add_ret = $LastExitCode
  if ($IsWindows -or $Env:OS) {
    return $ssh_add_ret
  }
  if (($ssh_add_ret -eq 2) -and (Test-Path ${HOME}/.ssh-agent.conf)) {
    ssh_agent_env
    ssh-add -l > $null 2>&1; $ssh_add_ret = $LastExitCode
  }
  if ($ssh_add_ret -eq 2) {
    ssh-agent | Out-File -FilePath ${HOME}/.ssh-agent.conf
    ssh_agent_env
    ssh-add -l > $null 2>&1; $ssh_add_ret = $LastExitCode
  }
  return $ssh_add_ret
}

function ssh_agent_add {
  $ssh_add_ret = $(ssh_agent_check)
  $sshAgentPid = [Environment]::GetEnvironmentVariable("SSH_AGENT_PID", "Process")
  if (-not $sshAgentPid) { $sshAgentPid = "NOCONFIG" }
  switch ($ssh_add_ret) {
    0 {
      Write-Host "Agent pid $sshAgentPid" -ForegroundColor Yellow
      ssh-add -l
    }
    1 {
      Write-Host "Agent pid $sshAgentPid" -ForegroundColor Yellow
      ssh-add
    }
    Default {
      Write-Host "No ssh-agent found" -ForegroundColor Red
    }
  }
}
Set-Alias a ssh_agent_add

function ssh_agent_del {
  ssh-add -d
}
Set-Alias k ssh_agent_del

# ssh_copy
# args[0] source file
# args[1] target file
function ssh_copy {
  if ($args.Count -ne 2 ) {
    Get-ChildItem -Path ${HOME}/.ssh/*.pub |
    ForEach-Object {
      Write-Host "`t" $_.Name.TrimEnd("\.pub") -ForegroundColor DarkYellow
    }
    return
  }
  ${src_file} = "${HOME}/.ssh/id_rsa"
  if ($args[0] -ne "_") {
    ${src_file} = ${src_file} + "_" + $args[0]
  }
  ${dest_file} = "${HOME}/.ssh/id_rsa"
  if ($args[1] -ne "_") {
    ${dest_file} = ${dest_file} + "_" + $args[1]
  }
  Copy-Item -Path "${src_file}" -Destination "${dest_file}" -Verbose
  Copy-Item -Path "${src_file}.pub" -Destination "${dest_file}.pub" -Verbose
}

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
      if ($args[$k] -eq "_") {
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

function git_branch_internal {
  $dir = $PWD.Path
  do {
    if (Test-Path "${dir}/.git/HEAD") {
      $head = Get-Content "${dir}/.git/HEAD"
      if ($head -eq $Global:GIT_NAME_HEAD) {
        return
      }
      $Global:GIT_NAME_HEAD = $head
      if ($head -match "^ref\:\ refs\/heads\/(?<branch>.*)") {
        $Global:GIT_NAME_TITLE = "branch"
        $Global:GIT_NAME_CONTENT = $Matches.branch
      }
      else {
        $describe = $(git describe --tags --abbrev=7 2> $null)
        if ($describe) {
          $Global:GIT_NAME_TITLE = "tag"
          $Global:GIT_NAME_CONTENT = $describe
        }
        else {
          $Global:GIT_NAME_TITLE = "commit"
          $Global:GIT_NAME_CONTENT = $head.Substring(0, 7)
        }
      }
      $Global:GIT_NAME_LEFT = ":["
      $Global:GIT_NAME_RIGHT = "]"
      "$Global:GIT_NAME_TITLE$Global:GIT_NAME_LEFT$Global:GIT_NAME_CONTENT$Global:GIT_NAME_RIGHT" | Out-Null
      return
    }
    ${dir} = Split-Path -Parent -Path "${dir}"
  } while (${dir})

  $Global:GIT_NAME_TITLE = ""
  $Global:GIT_NAME_CONTENT = ""
  $Global:GIT_NAME_LEFT = ""
  $Global:GIT_NAME_RIGHT = ""
  $Global:GIT_NAME_HEAD = ""
}

function prompt_custom {
  git_branch_internal
  Write-Host $(prompt_bak) -NoNewline
  Write-Host ${GIT_NAME_TITLE}${GIT_NAME_LEFT} -ForegroundColor Cyan -NoNewline
  Write-Host ${GIT_NAME_CONTENT} -ForegroundColor Yellow -NoNewline
  Write-Host ${GIT_NAME_RIGHT}">" -ForegroundColor Cyan -NoNewline
  # Prompt function requires a return, otherwise defaults to factory prompt
  return " "
}

function git_prompt {
  if (Get-Command prompt_bak -errorAction SilentlyContinue) {
    Copy-Item Function::Global:prompt_bak Function::Global:prompt
    Remove-Item Function::prompt_bak
    $Global:GIT_NAME_HEAD = ""; "$Global:GIT_NAME_HEAD" | Out-Null
  }
  else {
    Copy-Item Function::Global:prompt Function::Global:prompt_bak
    Copy-Item Function::Global:prompt_custom Function::Global:prompt
  }
}
Set-Alias p git_prompt

function git_status {
  git status
  git stash list 2> $null
  if ($?) { write-host "" }
  git ls-files -v  2> $null |
  ForEach-Object {
    if ($_ -cmatch "^S|^h|^M") {
      Write-Host $_ -ForegroundColor DarkRed
    }
  }
  if ($?) { write-host "" }
}
Set-Alias y git_status

function git_skip {
  git update-index --skip-worktree $args[0]
}

function git_noskip {
  if ($args.Count -eq 0) {
    git ls-files -v |
    ForEach-Object {
      if ($_ -cmatch "^S") {
        $v = $_.split(" ")[-1]
        git update-index --no-skip-worktree $v
        Write-Host $v -ForegroundColor DarkRed
      }
    }
  }
  else {
    git update-index --no-skip-worktree $args[0]
  }
}

function git_assume {
  git update-index --assume-unchanged $args[0]
}

function git_noassume {
  if ($args.Count -eq 0) {
    git ls-files -v |
    ForEach-Object {
      if ($_ -cmatch "^h") {
        $v = $_.split(" ")[-1]
        git update-index --no-assume-unchanged $v
        Write-Host $v -ForegroundColor DarkRed
      }
    }
  }
  else {
    git update-index --no-assume-unchanged $args[0]
  }
}

function git_top {
  git rev-parse --show-toplevel | Set-Location
}
Set-Alias t git_top

function git_haste {
  git_branch_internal
  if (-not ${GIT_NAME_TITLE}) {
    Write-Host "Not a git repository" -ForegroundColor Red
    return
  }
  elseif (${GIT_NAME_TITLE} -eq "branch") {
    git commit -m $(Get-Date -uformat "%Y-%m-%d %T %Z W%VD%u")
    if ($args -eq "commit") {
      return
    }
    if ($args -eq "rebase") {
      git fetch origin
      git rebase origin/${branch}
    }
    git push origin ${branch}:${branch}
  }
  else {
    Write-Host "Detached HEAD state" -ForegroundColor Red
  }
}

function git_sig {
  if ($args.Count -eq 0) {
    Write-Host "user.name: $(git config --get user.name)"
    Write-Host "user.email: $(git config --get user.email)"
  }
  elseif (($args.Count -eq 1) -and ($args -match "@")) {
    $v = $args.split("@")
    git config user.name $v[0]
    git config user.email $args
  }
  else {
    git config user.name $args[0]
    git config user.email $args[1]
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

# git config insteadOf
# $1: https/ssh/unset; null to display
# $2: domain name
function git_insteadof {
  $url = "github.com"
  if ($args.Count -ge 2) {
    $url = $args[1]
  }

  switch ($args[0]) {
    "ssh" {
      git config --global --unset-all url."https://${url}/".insteadof
      git config --global url."git@${url}:".insteadOf "https://${url}/"
    }
    "https" {
      git config --global --unset-all url."git@${url}:".insteadof
      git config --global url."https://${url}/".insteadOf "git@${url}:"
    }
    "unset" {
      git config --global --unset-all url."https://${url}/".insteadof
      git config --global --unset-all url."git@${url}:".insteadof
    }
    Default {
      git config -l |
      ForEach-Object {
        if ($_ -match "insteadof=") {
          Write-Host $_ -ForegroundColor DarkYellow
        }
      }
    }
  }
}

# Set git global set
function git_global_set {
  $isLocal = $false
  if ($args[0] -eq "local") {
    $isLocal = $true
  }
  update_internal $isLocal ".gitignore" ${HOME}/.gitignore
  # git global config
  git config --global core.excludesfile ${HOME}/.gitignore
  git config --global core.editor "vim"
  git config --global core.autocrlf false
  git config --global core.quotepath false
  git config --global pull.rebase false
  git config --global push.default simple
}

<########################
 # PoSH for Golang
 ########################>

if (-not $GOPATH_BAK) {
  $GOPATH_BAK = ${env:GOPATH}
}

# reset $GOPATH
function go_reset {
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

function go_proxy {
  if (-not $Env:GOPROXY) {
    env_amend GOPROXY "https://goproxy.cn"
    Write-Host "GOPROXY: $Env:GOPROXY" -ForegroundColor Yellow
  } else {
    env_unset GOPROXY
    Write-Host "GOPROXY: disabled" -ForegroundColor Yellow
  }
}

<########################
 # PoSH for Java
 ########################>

function mvn_gen {
  if ($args.Count -eq 1) {
    $values_array = $args[0].split(":")
    if ($values_array.count -eq 2) {
      $goupdId = $values_array[0]
      $artifactId = $values_array[1]
      "mvn archetype:generate ``
        '-DarchetypeGroupId=org.apache.maven.archetypes' ``
        '-DarchetypeArtifactId=maven-archetype-quickstart' ``
        '-DgroupId=$goupdId' ``
        '-DartifactId=$artifactId' ``
        '-Dversion=1.0-SNAPSHOT' ``
        '-DinteractiveMode=false'" | Invoke-Expression
    }
    else {
      Write-Host "GroupId:ArtifactId"
    }
  }
  else {
    mvn archetype:generate
  }
}

function mvn_exec {
  if ($args.Count -lt 1) {
    return
  }
  elseif ($args.Count -eq 1) {
    ${exec_name} = $args[0]
    "mvn exec:java '-Dexec.mainClass=`"${exec_name}`"'" | Invoke-Expression
  }
  else {
    ${exec_name} = $args[0]
    ${exec_args} = $args[1..$args.count]
    "mvn exec:java '-Dexec.mainClass=`"${exec_name}`"' '-Dexec.args=`"${exec_args}`"'" | Invoke-Expression
  }
}

<########################
 # PoSH for JavaScript
 ########################>

function npm_scripts {
  if ($(Test-Path package.json)) {
    $json = (Get-Content -Path package.json -Raw) | ConvertFrom-Json
    $json.scripts | ConvertTo-Json | Write-Host
  }
  else {
    Write-Host "No package.json found." -ForegroundColor Red
  }
}
Set-Alias j npm_scripts

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
    if (-not $(Test-Path $(Split-Path -Path $Local))) {
      New-Item -ItemType Directory -Path $(Split-Path -Path $Local)
    }
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
function update_configfiles {
  $isLocal = $false
  if ($args[0] -eq "local") {
    $isLocal = $true
  }
  # profile
  update_internal $isLocal "powershell/Microsoft.PowerShell_profile.ps1" $PROFILE
  # vim
  if (Get-Command vim -errorAction SilentlyContinue) {
    update_internal $isLocal "vim/.vimrc" "${HOME}/.vimrc"
    update_internal $isLocal "vim/.vimrc.bundles" "${HOME}/.vimrc.bundles"
    if (-not $(Test-Path ${HOME}/.vim/bundle)) {
      $ErrorActionPreference = "stop"; `
        git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim; `
        vim +BundleInstall +qall
    }
    else {
      vim +BundleInstall +qall
    }
  }
  # pip
  if (Get-Command pip -errorAction SilentlyContinue) {
    update_internal $true "pip/pip.conf" "${HOME}/.pip/pip.conf"
  }
  # npm
  if (Get-Command npm -errorAction SilentlyContinue) {
    update_internal $true "npm/.npmrc" "${HOME}/.npmrc"
  }
  # maven
  if (Get-Command mvn -errorAction SilentlyContinue) {
    update_internal $true "maven/settings.xml" "${HOME}/.m2/settings.xml"
  }
}

<########################
 # Envronment specific
 ########################>
if ($IsWindows -or $Env:OS) {
  Set-Alias grep Select-String
  function touch { New-Item "$args" -ItemType File }
  function sudo { Start-Process -Verb RunAs "$args" }

  function custom_cd {
    if ($args.Count -eq 0) {
      $tmp_path = ${HOME}
    }
    elseif ($args[0] -eq '-') {
      $tmp_path = $OLDPWD;
    }
    else {
      $tmp_path = $args[0];
    }
    if ($tmp_path) {
      Set-Variable -Name OLDPWD -Value $PWD -Scope global;
      Set-Location $tmp_path;
    }
  }
  Set-Alias cd custom_cd -Option AllScope
  function vs_env {
    $vs_wildcard = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\*\Community\Common7\Tools"
    if (-not $(Test-Path $vs_wildcard)) {
      return
    }
    $vs_path = Get-ChildItem $vs_wildcard
    Push-Location $vs_path[-1].FullName
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

  $vim_wildcard = "${Env:ProgramFiles(x86)}\Vim\*\vim.exe"
  if ($(Test-Path $vim_wildcard)) {
    $vim_path = Get-ChildItem $vim_wildcard
    Set-Alias vim $vim_path[-1].FullName
  }

  $code_path = "${Env:LOCALAPPDATA}\Programs\Microsoft VS Code\Code.exe" -replace ' ', '` '
  if ($(Test-Path $code_path)) {
    function code {
      "${code_path} $args" | Invoke-Expression > $null 2>&1
    }
  }
}
elseif ($(uname) -eq "Darwin") {
  # use "brew install gnu-*" instead of bsd-*
  Set-Alias -Name sed -Value gsed
  Set-Alias -Name awk -Value gawk
  Set-Alias -Name tar -Value gtar
  Set-Alias -Name find -Value gfind
  # open application from command
  function preview { open -a Preview $args }
  function typora { open -a Typora $args }
  function diffmerge { open -a DiffMerge $args }
  function code { open -a "Visual Studio Code" $args }
  function vlc { open -a VLC $args }
  function skim { open -a Skim $args }
  function drawio { open -a draw.io $args }
  function chrome { open -a "Google Chrome" $args }
  function firefox { open -a Firefox $args }
  function safari { open -a Safari $args }
  function edge { open -a "Microsoft Edge" $args }

}
elseif ($(uname) -eq "Linux") {
  function hello { Write-Host "hello" }
}

<########################
 # Echo Envronment
 ########################>
Write-Host ($PSVersionTable).OS -ForegroundColor DarkGreen
Write-Host "PowerShell Version:" ${PSVersionTable}.PSVersion.ToString() -ForegroundColor DarkCyan
