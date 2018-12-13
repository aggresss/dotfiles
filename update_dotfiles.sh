#!/bin/bash
# Update dotfiles from git@github.com:aggresss/dotfiles.git master branch
# wget https://raw.githubusercontent.com/aggresss/dotfiles/master/update_dotfiles.sh
set -euxo pipefail
shopt -s nullglob

DOTFILES_URL="https://github.com/aggresss/dotfiles/blob/master"
BASH_URL="https://github.com/aggresss/playground-bash/blob/master"

# $1 download url
# $2 local filepath
function update_file()
{
    local tmp_path="/tmp"
    # can replace by dirname and basename command
    local down_file=`echo "$1" | awk -F "/" '{print $NF}'`
    local down_path=`echo "$2" | awk 'BEGIN{res=""; FS="/";}{for(i=2;i<=NF-1;i++) res=(res"/"$i);} END{print res}'`
    if [ ! -d ${down_path} ]; then
        mkdir -vp ${down_path}
    fi
    rm -rvf ${tmp_path}/${down_file}
    wget -P ${tmp_path} $1
    cp -vf ${tmp_path}/${down_file} $2
    rm -vf ${tmp_path}/${down_file}
    if [ ${down_file##*.} = "sh" ]; then
        chmod +x $2
    fi
}

echo "=== Update dotfiles from git@github.com:aggresss/dotfiles.git master branch  ==="

# Update self
if [ ${HAS_UPDATED:-NoDefine} = "NoDefine" ]; then
    file_path=${HOME}/bin
    file_name=update_dotfiles.sh
    update_file ${DOTFILES_URL}/${file_name} ${file_path}/${file_name}
    chmod +x ${file_path}/${file_name}
    echo "--- Use updated update_dotfiles.sh to update dotfiles  ---"
    export HAS_UPDATED=1
    eval ${file_path}/${file_name}
    unset HAS_UPDATED
    exit 0
fi

# Update commom dotfiles
update_file ${DOTFILES_URL}/home/.bashrc ${HOME}/.bashrc
update_file ${DOTFILES_URL}/home/.bash_aliases ${HOME}/.bash_aliases
update_file ${DOTFILES_URL}/home/.inputrc ${HOME}/.inputrc
update_file ${DOTFILES_URL}/vim/.vimrc ${HOME}/.vimrc
update_file ${DOTFILES_URL}/vim/.vimrc.bundles ${HOME}/.vimrc.bundles
if [ ! -d ${HOME}/.vim/bundle ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
    && vim +BundleInstall +qall
fi
update_file ${DOTFILES_URL}/pip/pip.conf ${HOME}/.pip/pip.conf

# Update common bash utility
update_file ${BASH_URL}/hello.sh ${HOME}/bin/hello.sh

SYS_TYPE=`uname`
case ${SYS_TYPE} in
    Linux)
        update_file ${DOTFILES_URL}/home/.Xresources ${HOME}/.Xresources

    ;;
    Darwin)
        update_file ${DOTFILES_URL}/home/.bash_profile ${HOME}/.bash_profile

    ;;
    *)

    ;;
esac

