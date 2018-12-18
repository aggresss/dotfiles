# dotfiles

[![GitHub version](https://badge.fury.io/gh/aggresss%2Fdotfiles.svg)](https://badge.fury.io/gh/aggresss%2Fdotfiles)
[![Build Status](https://www.travis-ci.org/aggresss/dotfiles.svg?branch=master)](https://www.travis-ci.org/aggresss/dotfiles)
[![License](https://img.shields.io/github/license/aggresss/dotfiles.svg)](https://github.com/aggresss/dotfiles)


## $HOME Directory Specification

### 1. Common

| Drectory | Type | Illustrate |
|---|---|---|
| `~/Downloads` | **Delete Anytime** | common downloads repository |
| `~/Documents` | ***Periodic Backup*** | common documents repository |
| `~/Pictures` | ***Periodic Backup*** | common pictures repository |

### 2. Customized

| Drectory | Type | Illustrate |
|---|---|---|
| `~/bin` | *Auto Generation* | user executable files |
| `~/bak` | ***Periodic Backup*** | backup cache |
| `~/tmp` | **Delete Anytime** | temporary cache |
| `~/workspace-scratch` | *Auto Generation* | code workbench |
| `~/workspace-formal` | *Auto Generation* | code reference |
| `~/toolchain` | *Auto Generation* | toolchain repository |

| File | Type | Illustrate |
|---|---|---|
| `~/note.*` | ***Periodic Backup*** | notebook sort by classify |

### 3. Software

#### Golang

| Drectory | Type | Illustrate |
|---|---|---|
| `~/go` | *Auto Generation* | default GOPATH directory |
| `~/.local/go` | *Auto Generation* | default GOROOT directory |

#### Eclipse
| Drectory | Type | Illustrate |
|---|---|---|
| `~/eclipse-workspace` | *Auto Generation* | default eclipse workspace |
