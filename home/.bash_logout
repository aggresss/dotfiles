#!/usr/bin/env bash
# .bash_logout file for bash logout
#  wget https://raw.githubusercontent.com/aggresss/dotfiles/master/home/.bash_logout

# ssh-agent
if [ ${SSH_AGENT_PID:-NoDefine} != "NoDefine" ] ; then
  eval `ssh-agent -k`
fi
