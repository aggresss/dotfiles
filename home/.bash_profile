#!/usr/bin/env bash
# .bash_profile fork from Ubuntu:18.04 /etc/skel/.profile
# wget https://raw.githubusercontent.com/aggresss/dotfiles/master/home/.bash_profile
#
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true

