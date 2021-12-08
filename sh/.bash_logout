#!/usr/bin/env bash
# .bash_logout file for bash logout
#  wget https://raw.githubusercontent.com/aggresss/dotfiles/main/sh/.bash_logout

# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
  [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

# ssh-agent
if [ ${SSH_AGENT_PID:-NoDefine} != "NoDefine" ]; then
  eval $(ssh-agent -k)
fi
