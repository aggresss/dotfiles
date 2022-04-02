# dotfiles

[![Release Version](https://img.shields.io/github/v/release/aggresss/dotfiles)](https://github.com/aggresss/dotfiles/releases)
[![License](https://img.shields.io/github/license/aggresss/dotfiles)](https://github.com/aggresss/dotfiles/blob/main/LICENSE)
[![Build Status](https://www.travis-ci.org/aggresss/dotfiles.svg?branch=main)](https://www.travis-ci.org/aggresss/dotfiles)

## How To Use

- **Bash/Zsh**

```shell
curl https://raw.githubusercontent.com/aggresss/dotfiles/main/bin/update_dotfiles.sh -sSf | bash
```

- **PowerShell**

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
New-Item -Path "$PROFILE" -ItemType "file" -Force
Invoke-WebRequest `
    -Uri https://raw.githubusercontent.com/aggresss/dotfiles/main/powershell/Microsoft.PowerShell_profile.ps1 `
    -OutFile $PROFILE
Unblock-File $PROFILE

```

## $HOME Filesystem Hierarchy Standard

### 1. Common

| Drectory | Type | Illustrate |
|---|---|---|
| `~/Downloads/` | **Delete Anytime** | common downloads repository |
| `~/Documents/` | ***Periodic Backup*** | common documents repository |

### 2. Customized

| Drectory | Type | Illustrate |
|---|---|---|
| `~/bin/` | *Auto Generation* | user executable files |
| `~/notes/` | ***Periodic Backup*** | notes sort by classify |
| `~/dotfiless/` | ***Periodic Backup*** | dotfiles sort by classify |
| `~/workspace-scratch/` | *Auto Generation* | code workbench |
| `~/workspace-formal/` | *Auto Generation* | code reference |
| `~/workspace-zoo/` | *Auto Generation* | code forge (symbolic link) |

### 3. Software

#### VirtualBox

| Drectory | Type | Illustrate |
|---|---|---|
| `~/VirtualBox VMs/` | *Auto Generation* | default VirtualBox virtual machine directory |

#### Vagrant

| Drectory | Type | Illustrate |
|---|---|---|
| `~/Vagrant/` | *Auto Generation* | default Vagarant workspace |

#### Golang

| Drectory | Type | Illustrate |
|---|---|---|
| `~/go/` | *Auto Generation* | default GOPATH directory |
| `~/.local/go/` | *Auto Generation* | default GOROOT directory |

#### Rust

| Drectory | Type | Illustrate |
|---|---|---|
|`~/.cargo/`| *Auto Generation* | default Rust directory |

#### Python

| Drectory | Type | Illustrate |
|---|---|---|
| `~/env/` | **Delete Anytime** | python virtualenv directory |
| `~/.local/` | *Auto Generation* | pip user directory |

#### npm

| Drectory | Type | Illustrate |
|---|---|---|
| `~/.local/` | *Auto Generation* | npm global directory |

#### Perl
| Drectory | Type | Illustrate |
|---|---|---|
| `~/perl5/` | *Auto Generation* | default local::lib directory |
