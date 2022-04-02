<#
 # File: Microsoft.PowerShell_profile.ps1
 # URL: https://raw.githubusercontent.com/aggresss/dotfiles/main/PowerShell/Microsoft.PowerShell_profile.ps1
 # Before import this ps1 file, you need run these command:
 #     Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
 #>

<####################################
 # Environment Operate for PowerShell
 ####################################>

# ${env_level} possible values are { Prcess, User, Machine }
function internal_env_opration {
  Param (
    [Parameter(Mandatory = $true, Position = 0)] [bool]$is_insert,
    [Parameter(Mandatory = $true, Position = 1)] [string]$env_name,
    [Parameter(Mandatory = $true, Position = 2)] [String]$env_value,
    [Parameter(Mandatory = $false, Position = 3)] [String]$env_level = "Process"
  )
  if ($IsWindows -or $Env:OS) { $separator = ';' } else { $separator = ':' }
  $curr_values = [Environment]::GetEnvironmentVariable($env_name, $env_level)
  if ((-not $curr_values) -or ($curr_values -eq "")) {
    [Environment]::SetEnvironmentVariable($env_name, $env_value, $env_level)
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
      [Environment]::SetEnvironmentVariable($env_name, "$env_value$separator$curr_values", $env_level)
    }
    else {
      [Environment]::SetEnvironmentVariable($env_name, "$curr_values$separator$env_value", $env_level)
    }
  }
}

function env_insert {
  Param (
    [Parameter(Mandatory = $true, Position = 0)] [string]$env_name,
    [Parameter(Mandatory = $true, Position = 1)] [String]$env_value,
    [Parameter(Mandatory = $false, Position = 2)] [String]$env_level = "Process"
  )
  internal_env_opration $true $env_name $env_value $env_level
}

function env_append {
  Param (
    [Parameter(Mandatory = $true, Position = 0)] [string]$env_name,
    [Parameter(Mandatory = $true, Position = 1)] [String]$env_value,
    [Parameter(Mandatory = $false, Position = 2)] [String]$env_level = "Process"
  )
  internal_env_opration $false $env_name $env_value $env_level
}

function env_trim {
  Param (
    [Parameter(Mandatory = $true, Position = 0)] [string]$env_name,
    [Parameter(Mandatory = $true, Position = 1)] [String]$env_value,
    [Parameter(Mandatory = $false, Position = 2)] [String]$env_level = "Process"
  )
  if ($IsWindows -or $Env:OS) { $separator = ';' } else { $separator = ':' }
  $curr_values = [Environment]::GetEnvironmentVariable($env_name, $env_level)
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
      [Environment]::SetEnvironmentVariable($env_name, $new_value, $env_level)
    }
    else {
      if ($curr_values -eq $env_value) {
        [Environment]::SetEnvironmentVariable($env_name, $null, $env_level)
      }
    }
  }
}

function env_amend {
  Param (
    [Parameter(Mandatory = $true, Position = 0)] [string]$env_name,
    [Parameter(Mandatory = $true, Position = 1)] [String]$env_value,
    [Parameter(Mandatory = $false, Position = 2)] [String]$env_level = "Process"
  )
  [Environment]::SetEnvironmentVariable($env_name, $env_value, $env_level)
}

function env_unset {
  Param (
    [Parameter(Mandatory = $true, Position = 0)] [string]$env_name,
    [Parameter(Mandatory = $false, Position = 1)] [String]$env_level = "Process"
  )
  [Environment]::SetEnvironmentVariable($env_name, $null, $env_level)
}

function env_list {
  Param (
    [Parameter(Mandatory = $true, Position = 0)] [string]$env_name,
    [Parameter(Mandatory = $false, Position = 1)] [String]$env_level = "Process"
  )
  if ($IsWindows -or $Env:OS) { $separator = ';' } else { $separator = ':' }
  $curr_values = [Environment]::GetEnvironmentVariable($env_name, $env_level)
  if (($curr_values) -and (-not $curr_values -eq "")) {
    if ($curr_values -like "*$separator*") {
      $values_array = $curr_values.split("$separator")
      foreach ($value in $values_array) {
        Write-Host "$value"
      }
    }
    else {
      Write-Host "$curr_values"
    }
  }
}

<###########################
 # Git Prompt for PowerShell
 ###########################>

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

<############################
 # Source File for PowerShell
 ############################>

# source_file
# args[0] exec/copy/edit
# args[1] file
# args[2..-1] lines
function source_file {
  $note_dir = "${HOME}/notes/"
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
    # Process index of special file
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
      Write-Output $ReadyCacheArray
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

function source_file_copy {
  $run_script = "source_file copy"
  foreach ($a in $args) {
    $run_script += " $a"
  }
  $run_script | Invoke-Expression
}

function source_file_edit {
  $run_script = "source_file edit"
  foreach ($a in $args) {
    $run_script += " $a"
  }
  $run_script | Invoke-Expression
}

Set-Alias c source_file_copy
Set-Alias x source_file_exec
Set-Alias e source_file_edit

<#######################
 # Common for PowerShell
 #######################>

# Echo Env Information
Write-Host ($PSVersionTable).OS -ForegroundColor DarkGreen
Write-Host "PowerShell Version:" ${PSVersionTable}.PSVersion.ToString() -ForegroundColor DarkCyan

# Envronment specific
if ($IsWindows -or $Env:OS) {
  if (Test-Path Alias:\curl) { Remove-Item Alias:\curl }
  Set-Alias grep Select-String
  function touch { New-Item "$args" -ItemType File }
  function sudo {
    $processOptions = @{
      FilePath = "$args"
      WindowStyle = "Maximized"
      Verb = "RunAs"
    }
    Start-Process @processOptions
  }
  function etc_hosts { vim ${Env:SystemRoot}\System32\drivers\etc\hosts }
  function case_sensitive {
    switch ($args.Count) {
      1 {
        fsutil file queryCaseSensitiveInfo $args; break
      }
      2 {
        if ($args[1]) {
          fsutil file setCaseSensitiveInfo $args[0] enable
        } else {
          fsutil file setCaseSensitiveInfo $args[0] disable
        }
        break
      }
      Default {
        fsutil file queryCaseSensitiveInfo $PWD
      }
    }
  }
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
  function ln ($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target
  }
  function which ($target) {
    $obj = $(Get-Command $target)
    if ($obj) {
      Write-Output $obj
      switch ($obj.CommandType) {
        "Function" { Write-Output  "`n" $obj.definition }
      }
    }
  }
  # visual studio env
  function vs_env {
    $vs_wildcard = "${Env:ProgramFiles}\Microsoft Visual Studio\*\Community\Common7\Tools"
    if (-not $(Test-Path $vs_wildcard)) {
      $vs_wildcard = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\*\Community\Common7\Tools"
      if (-not $(Test-Path $vs_wildcard)) {
        Write-Host "`nVisual Studio has not been installed" -ForegroundColor Red
        return
      }
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
  # vim
  if ($(Test-Path "${Env:ProgramFiles(x86)}\Vim\*\vim.exe")) {
    Set-Alias vim (Get-ChildItem "${Env:ProgramFiles(x86)}\Vim\*\vim.exe")[-1].FullName
  }
  # emacs
  if ($(Test-Path "${Env:ProgramFiles}\Emacs\*\bin\emacs.exe")) {
    function emacs {
       $emacs_path = (Get-ChildItem "${Env:ProgramFiles}\Emacs\*\bin\emacs.exe")[-1].FullName -replace ' ', '` '
      "$emacs_path -nw $args" | Invoke-Expression
    }
  }
  # vscode
  if ($(Test-Path "${Env:LOCALAPPDATA}\Programs\Microsoft VS Code\bin")) {
    if (-not $(Get-Command code -errorAction SilentlyContinue)) {
      env_insert "PATH" "${Env:LOCALAPPDATA}\Programs\Microsoft VS Code\bin" "User"
    }
  }
  # ${HOME}\bin
  $bin_path = Join-Path -Path ${HOME} -ChildPath 'bin'
  if (-not $(Test-Path $bin_path)) {
    New-Item $bin_path -ItemType directory -Force
    env_insert "PATH" $bin_path "User"
  }
  Remove-Variable -Name bin_path
}
elseif ($(uname) -eq "Darwin") {
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

# short for cd ..
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../../ }
function ..... { Set-Location ../../../../ }

function u { . $PROFILE }
function o { Write-Output $? }
function ll {
  if ((Get-Command ls).CommandType -eq "Application") {
    "ls -al" | Invoke-Expression
  }
  else {
    Get-ChildItem -Attributes !System, Hidden
  }
}

function mkdir_cd {
  Param (
    [Parameter(Mandatory = $true, Position = 0)] [string]$folder_name,
    [Parameter(Mandatory = $false, Position = 1)] [bool]$caseSensitive = $false
  )
  if (-not $(Test-Path $folder_name)) {
    New-Item $folder_name -ItemType directory -Force
    if (($IsWindows -or $Env:OS) -and $caseSensitive) {
      "fsutil file setCaseSensitiveInfo $folder_name enable" | Invoke-Expression
    }
  }
  Set-Location $folder_name
}
function s { mkdir_cd "${HOME}/workspace-scratch" $true }
function f { mkdir_cd "${HOME}/workspace-formal" $true }
function z { Set-Location "${HOME}/workspace-zoo" }
function d { mkdir_cd "${HOME}/Downloads" }
function m { mkdir_cd "${HOME}/Documents" }

# Update
function update_internal {
  Param (
    [Parameter(Mandatory = $true, Position = 0)] [bool]$IsLocal,
    [Parameter(Mandatory = $true, Position = 1)] [String]$Remote,
    [Parameter(Mandatory = $true, Position = 2)] [String]$Local
  )
  $local_base_path = "${HOME}/dotfiles"
  $remote_base_url = "https://raw.githubusercontent.com/aggresss/dotfiles/main"
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
  # Profile
  $PROFILE_PATH = Split-Path -Path $PROFILE
  update_internal $isLocal "powershell/Microsoft.PowerShell_profile.ps1" ${PROFILE_PATH}/Microsoft.PowerShell_profile.ps1
  update_internal $isLocal "powershell/Microsoft.PowerShell_profile.ps1" ${PROFILE_PATH}/Microsoft.VSCode_profile.ps1
  # Windows Envrionment
  if ($IsWindows -or $Env:OS) {
    # Vim
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
    # Emacs
    if (Get-Command emacs -errorAction SilentlyContinue) {
      update_internal $isLocal "emacs/.emacs" "${Env:APPDATA}/.emacs"
    }
    # pip
    if (Get-Command pip -errorAction SilentlyContinue) {
      update_internal $true "pip/pip.conf" "${HOME}/pip/pip.ini"
    }
    # npm
    if (Get-Command npm -errorAction SilentlyContinue) {
      update_internal $true "npm/.npmrc" "${HOME}/.npmrc"
    }
    # Maven
    if (Get-Command mvn -errorAction SilentlyContinue) {
      update_internal $true "maven/settings.xml" "${HOME}/.m2/settings.xml"
    }
  }
}

<####################
 # SSH for PowerShell
 ####################>

function ssh_agent_env {
  Param (
    [Parameter(Mandatory = $false)] [String]$ssh_agent_config
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
      break
    }
    1 {
      Write-Host "Agent pid $sshAgentPid" -ForegroundColor Yellow
      ssh-add
      break
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

<####################
 # Git for PowerShell
 ####################>

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
    Write-Host "Please input remote name and pull request No." -ForegroundColor Red
    return
  }
  $remote_name = $args[0]
  $remote_pr = $args[1]
  $pull_branch = "pull/${remote_name}/${remote_pr}"
  $curr_branch = $(git rev-parse --abbrev-ref HEAD); if (-not $?) { return }
  git fetch ${remote_name} pull/${remote_pr}/head:${pull_branch}_staging; if (-not $?) { return }
  if (${pull_branch} -eq ${curr_branch}) {
    git rebase ${pull_branch}_staging
  }
  else {
    git branch -q -D ${pull_branch} 2> $null
    git checkout -b ${pull_branch} ${pull_branch}_staging
  }
  git branch -q -D ${pull_branch}_staging
}

function git_leave {
  if ($args.Count -lt 1 ) {
    Write-Host "Please input a branch to checkout." -ForegroundColor Red
    return
  }
  $curr_branch = $(git rev-parse --abbrev-ref HEAD)
  if ((-not ${curr_branch}) -or (${curr_branch} -eq "")) {
    return
  }
  git checkout $args[0]; if (-not $?) { return }
  git branch -D ${curr_branch}
}

function git_log {
  git log --oneline $args
}

function git_diff {
  git diff --name-status $args
}

function git_branch {
  git branch -vv $args
}
Set-Alias b git_branch

# clone repo in hierarchy directory as org/repo
# suit for https://site/org/repo.git or git@site:org/repo.git
# $1: repo URI
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
  # trim suffix
  $clone_path = $clone_path.TrimEnd("/")
  $clone_path = $clone_path.TrimEnd(".git")
  # trim site if exist org
  if ($clone_path.split("/").Length -eq 3) {
    $clone_path = $clone_path.split("/", 2)[1]
  }
  # execute
  git clone --origin upstream $args $clone_path
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
      break
    }
    "https" {
      git config --global --unset-all url."git@${url}:".insteadof
      git config --global url."https://${url}/".insteadOf "git@${url}:"
      break
    }
    "unset" {
      git config --global --unset-all url."https://${url}/".insteadof
      git config --global --unset-all url."git@${url}:".insteadof
      break
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
  if ($IsWindows -or $Env:OS) {
    [Environment]::SetEnvironmentVariable("LESSCHARSET", "utf-8", "User")
  }
  # git global config
  git config --global core.excludesfile ${HOME}/.gitignore
  git config --global core.editor "vim"
  git config --global core.autocrlf false
  git config --global core.quotepath false
  git config --global core.ignorecase false
  git config --global user.useConfigOnly true
  git config --global pull.rebase false
  git config --global push.default simple
  git config --global init.defaultBranch main
}

function git_latest {
  git describe --tags $(git rev-list --tags --max-count=1)
}

# git set-upstream-to
# $1 upstream
function git_set_upstream {
  git branch --set-upstream-to=$args
}

<#######################
 # VSCode for PowerShell
 #######################>
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

<######################
# Docker for PowerShell
#######################>

# Run and mount private file
function docker_private {
  if (!$(docker volume ls | Select-String root)) {
    docker volume create root
  }
  if (!$(docker volume ls | Select-String home)) {
    docker volume create home
  }

  if ($IsWindows -or $Env:OS) {
    docker run --rm -it `
      -v root:/root `
      -v home:/home `
      -v ${HOME}/notes:/mnt/notes `
      -v ${HOME}/Downloads:/mnt/Downloads `
      -v ${HOME}/Documents:/mnt/Documents `
      -v ${HOME}/workspace-scratch:/mnt/workspace-scratch `
      -v ${HOME}/workspace-formal:/mnt/workspace-formal `
      -e DISPLAY=host.docker.internal:0 `
      $args
  }
  elseif ($(uname) -eq "Darwin") {
    xhost +localhost > /dev/null
    docker run --rm -it `
      -v root:/root `
      -v home:/home `
      -v ${HOME}/notes:/mnt/notes `
      -v ${HOME}/Downloads:/mnt/Downloads `
      -v ${HOME}/Documents:/mnt/Documents `
      -v ${HOME}/workspace-scratch:/mnt/workspace-scratch `
      -v ${HOME}/workspace-formal:/mnt/workspace-formal `
      -e DISPLAY=host.docker.internal:0 `
      $args
  }
  elseif ($(uname) -eq "Linux") {
    $docker_host = $(docker network inspect --format='{{range .IPAM.Config}}{{.Gateway}}{{end}}' bridge)
    xhost +local:docker > /dev/null
    docker run --rm -it `
      --add-host=host.docker.internal:${docker_host} `
      -v /tmp/.X11-unix/:/tmp/.X11-unix `
      -v root:/root `
      -v home:/home `
      -v ${HOME}/notes:/mnt/notes `
      -v ${HOME}/Downloads:/mnt/Downloads `
      -v ${HOME}/Documents:/mnt/Documents `
      -v ${HOME}/workspace-scratch:/mnt/workspace-scratch `
      -v ${HOME}/workspace-formal:/mnt/workspace-formal `
      -e DISPLAY `
      $args
  }
}

# Run private with super privilage
function docker_sudo {
  docker_private `
    --privileged=true `
    $args
}

# Run private with user
function docker_user {
  docker_private `
    --privileged=true `
    --user=docker `
    $args
}

# killall containers
function docker_kill {
  if ($(docker ps -a -q)) {
    docker rm -f $(docker ps -a -q)
  }
}

<#######################
 # Golang for PowerShell
 #######################>

if (-not $GOPATH_BAK) {
  $GOPATH_BAK = ${env:GOPATH}
}

# reset $GOPATH
function go_reset {
  ${env:GOPATH} = ${GOPATH_BAK}
  Write-Host "Successful clear GOPATH: ${env:GOPATH}"
}
function go_pwd { env_amend GOPATH "${PWD}" }

function go_env {
  Write-Host "GOPATH" -ForegroundColor Green
  env_list GOPATH
  Write-Host "GODEBUG" -ForegroundColor Green
  env_list GODEBUG
}
Set-Alias g go_env

function go_proxy {
  if (-not $Env:GOPROXY) {
    env_amend GOPROXY "https://goproxy.cn"
    Write-Host "GOPROXY: $Env:GOPROXY" -ForegroundColor Yellow
  }
  else {
    env_unset GOPROXY
    Write-Host "GOPROXY: disabled" -ForegroundColor Yellow
  }
}

<#####################
 # Java for PowerShell
 #####################>

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

<##########################
 # JavaScript for PowerShell
 ##########################>

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

# End of Microsoft.PowerShell_profile.ps1
