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
