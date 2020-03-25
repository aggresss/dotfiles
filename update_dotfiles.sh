#!/usr/bin/env bash
# Update dotfiles from git@github.com:aggresss/dotfiles.git master branch
# curl https://raw.githubusercontent.com/aggresss/dotfiles/master/update_dotfiles.sh -sSf | bash

DOTFILES_URL="https://github.com/aggresss/dotfiles/raw/master"
BASH_URL="https://github.com/aggresss/playground-bash/raw/master"

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
    if [ $(command -v wget > /dev/null; echo $?) -eq 0 ]; then
        wget -P ${tmp_path} $1
    elif [ $(command -v curl > /dev/null; echo $?) -eq 0 ]; then
        cd ${tmp_path}
        curl -OL $1
        cd -
    else
        echo "No http request tool."
        exit 1;
    fi
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
update_file ${DOTFILES_URL}/home/.bash_aliases ${HOME}/.bash_aliases
update_file ${DOTFILES_URL}/home/.inputrc ${HOME}/.inputrc
update_file ${DOTFILES_URL}/tmux/.tmux.conf ${HOME}/.tmux.conf
update_file ${DOTFILES_URL}/vim/.vimrc ${HOME}/.vimrc
update_file ${DOTFILES_URL}/vim/.vimrc.bundles ${HOME}/.vimrc.bundles
# vim
if [ ! -d ${HOME}/.vim/bundle ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim \
    && vim +BundleInstall +qall
else
    vim +BundleInstall +qall
fi

update_file ${DOTFILES_URL}/pip/pip.conf ${HOME}/.pip/pip.conf
# .bash_profile
if [ ! -f ${HOME}/.bash_profile ]; then
    if [ -f /etc/skel/.bash_profile ]; then
        cp /etc/skel/.bash_profile ${HOME}/
    else
        update_file ${DOTFILES_URL}/home/.bash_profile ${HOME}/.bash_profile
    fi
fi

# shell rc
if [[ ${SHELL} =~ .*zsh$ ]]; then
    if [ ! -f ${HOME}/.zshrc ]; then
        update_file ${DOTFILES_URL}/home/.zshrc ${HOME}/.zshrc
        update_file ${DOTFILES_URL}/home/.zprofile ${HOME}/.zprofile
    fi

    if ! cat ${HOME}/.zshrc | grep -q ".bash_aliases"; then
        cat << END >> ${HOME}/.zshrc

# modify by aggresss
if [ -f ${HOME}/.bash_aliases ]; then
    . ${HOME}/.bash_aliases
fi

END

    fi

elif [[ ${SHELL} =~ .*bash$ ]]; then
    if [ ! -f ${HOME}/.bashrc ]; then
        if [ -f /etc/skel/.bashrc ]; then
            cp /etc/skel/.bashrc ${HOME}/
        else
            update_file ${DOTFILES_URL}/home/.bashrc ${HOME}/.bashrc
        fi
    fi

    if ! cat ${HOME}/.bashrc | grep -q ".bash_aliases"; then
        cat << END >> ${HOME}/.bashrc

# modify by aggresss
if [ -f ${HOME}/.bash_aliases ]; then
    . ${HOME}/.bash_aliases
fi

END

    fi

fi

# .bash_logout
if [ ! -f ${HOME}/.bash_logout ]; then
    if [ -f /etc/skel/.bash_logout ]; then
        cp /etc/skel/.bash_logout ${HOME}/
    else
        update_file ${DOTFILES_URL}/home/.bash_logout ${HOME}/.bash_logout
    fi
fi

if ! cat ${HOME}/.bash_logout | grep -q "ssh-agent -k"; then
    cat << END >> ${HOME}/.bash_logout

# modify by aggresss
# ssh-agent
if [ ${SSH_AGENT_PID:-NoDefine} != "NoDefine" ] ; then
  eval `ssh-agent -k`
fi

END
fi

# Update common bash utility
update_file ${BASH_URL}/hello.sh ${HOME}/bin/hello.sh

case $(uname) in
    Linux)
        update_file ${DOTFILES_URL}/home/.Xresources ${HOME}/.Xresources
    ;;
    Darwin)
        echo "Darwin"
    ;;
    FreeBSD)
        echo "FreeBSD"
    ;;
    MINGW*)
        echo "MINGW"
    ;;
    *)
        echo "No support this ENV"
    ;;
esac

