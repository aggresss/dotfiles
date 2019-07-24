#!/usr/bin/env bash
# .bash_profile fork from Ubuntu:18.04 /etc/skel/.profile
# wget https://raw.githubusercontent.com/aggresss/dotfiles/master/home/.bash_profile
#
# ~/.profile: executed by Bourne-compatible login shells.

if [[ $(uname) == "Darwin" ]]; then
    export LC_ALL=en_US.UTF-8
fi

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true

