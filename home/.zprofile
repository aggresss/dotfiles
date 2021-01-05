# wget https://raw.githubusercontent.com/aggresss/dotfiles/master/home/.zprofile
#
# ~/.zprofile: executed by Bourne-compatible login shells.

if [[ $(uname) == "Darwin" ]]; then
    export LC_ALL=en_US.UTF-8
fi
