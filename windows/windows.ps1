# Install list

winget install Microsoft.PowerToys
winget install Git.Git
winget install Kitware.CMake
winget install vim.vim
winget install GNU.Emacs
winget install marha.VcXsrv
winget install Graphviz.Graphviz
winget install Python.Python
winget install StrawberryPerl.StrawberryPerl
winget install RubyInstallerTeam.Ruby
winget install OpenJS.NodeJS
winget install Google.Chrome
winget install Mozilla.Firefox
winget install Microsoft.Edge
winget install VideoLAN.VLC
winget install WiresharkFoundation.Wireshark
winget install Microsoft.VisualStudioCode-User-x64
winget install Microsoft.VisualStudio.Community
winget install CPUID.GPU-Z
winget install TechPowerUpCPU-Z

# Environment management

## Perl
$perl_path = "${Env:HOMEDRIVE}\Strawberry\perl\bin"
if ($(Test-Path $perl_path)) {
  env_append PATH (Resolve-Path $perl_path)[-1] User
}

## Ruby
$ruby_path = "${Env:HOMEDRIVE}\Ruby*\bin"
if ($(Test-Path $ruby_path)) {
  env_append PATH (Resolve-Path $ruby_path)[-1] User
}

## Lua
$lua_path = "${Env:USERPROFILE}\lua"
if ($(Test-Path $lua_path)) {
  env_append PATH (Get-ChildItem $lua_path)[-1].FullName User
}

## Maven
$maven_path = "${Env:USERPROFILE}\maven\*\bin"
if ($(Test-Path $maven_path)) {
  env_append PATH (Resolve-Path $maven_path)[-1] User
}
