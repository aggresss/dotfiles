# dotfiles

[![GitHub version](https://badge.fury.io/gh/aggresss%2Fdotfiles.svg)](https://badge.fury.io/gh/aggresss%2Fdotfiles)
[![Build Status](https://www.travis-ci.org/aggresss/dotfiles.svg?branch=master)](https://www.travis-ci.org/aggresss/dotfiles)
[![License](https://img.shields.io/github/license/aggresss/dotfiles.svg)](https://github.com/aggresss/dotfiles)

## How To Use

```shell
curl https://raw.githubusercontent.com/aggresss/dotfiles/master/bin/update_dotfiles.sh -sSf | bash
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
| `~/bak/` | ***Periodic Backup*** | backup cache |
| `~/tmp/` | **Delete Anytime** | temporary cache |
| `~/workspace-scratch/` | *Auto Generation* | code workbench |
| `~/workspace-formal/` | *Auto Generation* | code reference |
| `~/toolchain/` | *Auto Generation* | toolchain repository |
| `~/note/` | ***Periodic Backup*** | notebook sort by classify |

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

### npm

| Drectory | Type | Illustrate |
|---|---|---|
| `~/.npm-packages/` | *Auto Generation* | npm global directory |

#### Eclipse
| Drectory | Type | Illustrate |
|---|---|---|
| `~/.local/eclipse/` | *Auto Generation* | default eclipse install directory |
| `~/eclipse-workspace/` | *Auto Generation* | default eclipse workspace directory |

#### Visual Studio Code
| Drectory | Type | Illustrate |
|---|---|---|
| `~/code-workspace/` | *Auto Generation* | default Visual Studio Code workspace directory |

## Stargazers over time

[![Stargazers over time](https://starchart.cc/aggresss/dotfiles.svg)](https://starchart.cc/aggresss/dotfiles)
