## Software for windows

OpenJDK by Red Hat
- https://developers.redhat.com/products/openjdk/download

Maven
- https://maven.apache.org/download.cgi

Cascadia Code Font
- https://github.com/microsoft/cascadia-code/releases

JetBrains Mono Font
- https://www.jetbrains.com/lp/mono/

## Using ssh-agent with git on Windows

```
Get-Service ssh-agent | Set-Service -StartupType Automatic

[Environment]::SetEnvironmentVariable("GIT_SSH", "$((Get-Command ssh).Source)", [System.EnvironmentVariableTarget]::User)
```
