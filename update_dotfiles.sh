#!/bin/bash
# Update dotfiles from git@github.com:aggresss/dotfiles.git master branch
# wget https://raw.githubusercontent.com/aggresss/dotfiles/master/update_dotfiles.sh
set -euxo pipefail
shopt -s nullglob

DOTFILES_URL="https://raw.githubusercontent.com/aggresss/dotfiles/master"
BASH_URL="https://raw.githubusercontent.com/aggresss/playground-bash/master"

# $1 download url
# $2 local filepath
function update_file()
{
    TMP_PATH="/tmp"
    # can replace by dirname and basename command
    DOWN_FILE=`echo "$1" | awk -F "/" '{print $NF}'`
    DOWN_PATH=`echo "$2" | awk 'BEGIN{res=""; FS="/";}{for(i=2;i<=NF-1;i++) res=(res"/"$i);} END{print res}'`
    if [ ! -d ${DOWN_PATH} ]; then
        mkdir -vp ${DOWN_PATH}
    fi
    rm -rvf ${TMP_PATH}/${DOWN_FILE}
    wget -P ${TMP_PATH} $1
    cp -vf ${TMP_PATH}/${DOWN_FILE} $2
    rm -vf ${TMP_PATH}/${DOWN_FILE}
    if [ ${DOWN_FILE##*.} = "sh" ]; then
        chmod +x $2
    fi
}

echo "=== Update dotfiles from git@github.com:aggresss/dotfiles.git master branch  ==="

# Update self
if [ ${HAS_UPDATED:-NoDefine} = "NoDefine" ]; then
    FILE_PATH=${HOME}/bin
    FILE_NAME=update_dotfiles.sh
    update_file ${DOTFILES_URL}/${FILE_NAME} ${FILE_PATH}/${FILE_NAME}
    chmod +x ${FILE_PATH}/${FILE_NAME}
    echo "--- Use updated update_dotfiles.sh to update dotfiles  ---"
    export HAS_UPDATED=1
    eval ${FILE_PATH}/${FILE_NAME}
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

