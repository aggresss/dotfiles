
## How To Use

```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
New-Item -Path "$PROFILE" -ItemType "file" -Force
Invoke-WebRequest `
    -Uri https://raw.githubusercontent.com/aggresss/dotfiles/master/powershell/Microsoft.PowerShell_profile.ps1 `
    -OutFile $PROFILE | Unblock-File
```
