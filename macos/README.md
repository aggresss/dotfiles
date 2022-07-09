# macOS Configuration

## Software Need Manually Install

name | Website
:---:|---
Homebrew | https://brew.sh/

## Finder

```
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
defaults write com.apple.finder AppleShowAllFiles true
killall Finder
```

## Dock

```
defaults write com.apple.dock springboard-columns -int 8
defaults write com.apple.dock springboard-rows -int 7
defaults write com.apple.dock ResetLaunchPad -bool TRUE
killall Dock
```

## iTerm2

```
iTerm2 -> General -> Selection -> Applications in terminal may access clipboard
```
