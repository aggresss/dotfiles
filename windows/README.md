## Software for windows

Create bootable USB drives the easy way
- http://rufus.ie/

OpenJDK by Red Hat
- https://developers.redhat.com/products/openjdk/download

Maven
- https://maven.apache.org/download.cgi

Cascadia Code Font
- https://github.com/microsoft/cascadia-code

JetBrains Mono Font
- https://github.com/JetBrains/JetBrainsMono

Sysinternals Suite
- https://docs.microsoft.com/en-us/sysinternals/downloads/

FFmpeg
- https://www.gyan.dev/ffmpeg/builds/

MKVToolnix
- https://www.fosshub.com/MKVToolNix.html

---

## Using ssh-agent with git on Windows

```
Get-Service ssh-agent | Set-Service -StartupType Automatic

[Environment]::SetEnvironmentVariable("GIT_SSH", "$((Get-Command ssh).Source)", [System.EnvironmentVariableTarget]::User)
```

## Windows optional feature

```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

## Windows capability

```
dism /Online /Get-Capabilities | findstr OpenSSH
dism /Online /Add-Capability /CapabilityName:OpenSSH.Client~~~~0.0.1.0
dism /Online /Add-Capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0
```

## Windows service management

```
Start-Service ssh-agent
Set-Service -Name ssh-agent -StartupType 'Automatic'
```