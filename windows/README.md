# Windows Configuration

## Windows software

- [Rufus](http://rufus.ie/)
- [OpenJDK](https://developers.redhat.com/products/openjdk/download)
- [Maven](https://maven.apache.org/download.cgi)
- [Cascadia Code Font](https://github.com/microsoft/cascadia-code)
- [JetBrains Mono Font](https://github.com/JetBrains/JetBrainsMono)
- [Sysinternals Suite](https://docs.microsoft.com/en-us/sysinternals/downloads/)
- [FFmpeg](https://www.gyan.dev/ffmpeg/builds/)
- [MKVToolnix](https://www.fosshub.com/MKVToolNix.html)
- [VcXsrv](https://sourceforge.net/projects/vcxsrv/)
- [PulseAudio](https://www.freedesktop.org/wiki/Software/PulseAudio/Ports/Windows/Support/)

```
winget install --id Git.Git
winget install --id Kitware.CMake
winget install --id vim.vim
winget install --id 7zip.7zip
winget install --id GNU.Emacs
winget install --id GnuWin32.make
winget install --id marha.VcXsrv
winget install --id SourceGear.DiffMerge
winget install --id Graphviz.Graphviz
winget install --id JGraph.Draw
winget install --id VideoLAN.VLC
winget install --id WiresharkFoundation.Wireshark
winget install --id Postman.Postman
winget install --id Python.Python
winget install --id StrawberryPerl.StrawberryPerl
winget install --id RubyInstallerTeam.Ruby
winget install --id OpenJS.NodeJS
winget install --id Google.Chrome
winget install --id Mozilla.Firefox
winget install --id Microsoft.Edge
winget install --id Microsoft.PowerToys
winget install --id Microsoft.VisualStudioCode
winget install --id Microsoft.VisualStudio.Community
winget install --id CPUID.GPU-Z
winget install --id TechPowerUpCPU-Z
```

## Windows environment

```
## Git
[Environment]::SetEnvironmentVariable("GIT_SSH", "$((Get-Command ssh).Source)", [System.EnvironmentVariableTarget]::User)

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

## GnuWin32
$gnuwin32_path = "${Env:ProgramFiles(x86)}\GnuWin32\bin"
if ($(Test-Path $gnuwin32_path)) {
  env_append PATH (Resolve-Path $gnuwin32_path)[-1] User
}
```

## Windows optional feature

```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

## Windows capability

```
## OpenSSH
dism /Online /Get-Capabilities | findstr OpenSSH
dism /Online /Add-Capability /CapabilityName:OpenSSH.Client~~~~0.0.1.0
dism /Online /Add-Capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0
```

## Windows service

```
Start-Service ssh-agent
Set-Service -Name ssh-agent -StartupType 'Automatic'
```

## Windows registry

```
## Windows11 taskbar size
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSi /t REG_DWORD /d 0 /f
## Realtime univeral
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_QWORD /d 1 /f
## Disable activity feed
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f
```

## Windows firewall

```
## WSL Setting
New-NetFirewallRule -DisplayName "WSL" -Direction Inbound  -InterfaceAlias "vEthernet (WSL)"  -Action Allow
## Reset SecHealthUI
Get-AppxPackage Microsoft.SecHealthUI -AllUsers | Reset-AppxPackage
```

## Windows manual setting

```
Personalization > Background > Solid color > rgb(1, 133, 116)
Update & security > Advanced options > Delivery Optimization > Off
```
