#!/usr/bin/env zsh
# .z_logout file for zsh logout
#  wget https://raw.githubusercontent.com/aggresss/dotfiles/master/home/.zlogout

# ~/.zlogout: executed by zsh(1) when login shell exits.

# ssh-agent
if [ ${SSH_AGENT_PID:-NoDefine} != "NoDefine" ] ; then
  eval `ssh-agent -k`
fi
