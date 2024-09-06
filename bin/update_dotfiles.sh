#!/usr/bin/env bash
# Update dotfiles from git@github.com:aggresss/dotfiles.git main branch
# curl https://raw.githubusercontent.com/aggresss/dotfiles/main/bin/update_dotfiles.sh -sSf | bash

# Remote or local
if [ ${1:-NoDefine} = "local" ] && [ -d ${HOME}/dotfiles ]; then
    UPDATE_METHOD="local"
    DOTFILES_URL="${HOME}/dotfiles"
else
    UPDATE_METHOD="remote"
    DOTFILES_URL="https://github.com/aggresss/dotfiles/raw/main"
fi

# $1 download url
# $2 local filepath
function update_file() {
    local tmp_path="/tmp"
    # can replace by dirname and basename command
    local down_file=$(echo "$1" | awk -F "/" '{print $NF}')
    local down_path=$(echo "$2" | awk 'BEGIN{res=""; FS="/";}{for(i=2;i<=NF-1;i++) res=(res"/"$i);} END{print res}')
    echo "Update $2 ..."
    if [ ! -d ${down_path} ]; then
        mkdir -vp ${down_path}
    fi
    if [[ $1 =~ ^http.* ]]; then
        rm -rf ${tmp_path}/${down_file}
        if [ $(
            command -v wget >/dev/null
            echo $?
        ) -eq 0 ]; then
            wget -P ${tmp_path} $1
        elif [ $(
            command -v curl >/dev/null
            echo $?
        ) -eq 0 ]; then
            cd ${tmp_path}
            curl -OL $1
            cd -
        else
            echo "No http request tool."
            exit 1
        fi
        cp -vf ${tmp_path}/${down_file} $2
        rm -rf ${tmp_path}/${down_file}
        if [ ${down_file##*.} = "sh" ]; then
            chmod +x $2
        fi
    else
        cp -vf $1 $2
    fi
}

echo "=== Update dotfiles from git@github.com:aggresss/dotfiles.git main branch  ==="

# Update self
if [ ${HAS_UPDATED:-NoDefine} = "NoDefine" ]; then
    file_path=${HOME}/bin
    file_name=update_dotfiles.sh
    update_file ${DOTFILES_URL}/bin/${file_name} ${file_path}/${file_name}
    chmod +x ${file_path}/${file_name}
    echo "--- Use updated update_dotfiles.sh to update dotfiles  ---"
    export HAS_UPDATED=1
    eval ${file_path}/${file_name} ${UPDATE_METHOD}
    unset HAS_UPDATED
    exit 0
fi

# Update commom dotfiles
update_file ${DOTFILES_URL}/sh/.bash_aliases ${HOME}/.bash_aliases
update_file ${DOTFILES_URL}/sh/.inputrc ${HOME}/.inputrc
COMMON_FILES="\
    hello.sh \
    go_up.sh \
    rust_up.sh \
"

if [ $(
    which docker-entrypoint.sh >/dev/null
    echo $?
) -eq 0 ]; then
    COMMON_FILES="${COMMON_FILES} link_elementary.sh"
fi

for CF in $(echo ${COMMON_FILES}); do
    update_file ${DOTFILES_URL}/bin/${CF} ${HOME}/bin/${CF}
done

# ssh
if [ ! -d ${HOME}/.ssh ]; then
    mkdir -p ${HOME}/.ssh
fi
if [ ! -f ${HOME}/.ssh/config ]; then
    update_file ${DOTFILES_URL}/ssh/config ${HOME}/.ssh/config
fi
# vim
if [ $(
    command -v vim >/dev/null
    echo $?
) -eq 0 ] && [ ! -f ${HOME}/.vimrc ]; then
    update_file ${DOTFILES_URL}/vim/.vimrc ${HOME}/.vimrc
fi
# emacs
if [ $(
    command -v emacs >/dev/null
    echo $?
) -eq 0 ] && [ ! -f ${HOME}/.emacs ]; then
    update_file ${DOTFILES_URL}/emacs/.emacs ${HOME}/.emacs
fi
# tmux
if [ $(
    command -v tmux >/dev/null
    echo $?
) -eq 0 ] && [ ! -f ${HOME}/.tmux.conf ]; then
    update_file ${DOTFILES_URL}/tmux/.tmux.conf ${HOME}/.tmux.conf
fi
# pip
if [ $(
    command -v pip >/dev/null
    echo $?
) -eq 0 ]; then
    update_file ${DOTFILES_URL}/pip/pip.conf ${HOME}/.pip/pip.conf
fi
# npm
if [ $(
    command -v npm >/dev/null
    echo $?
) -eq 0 ]; then
    update_file ${DOTFILES_URL}/npm/.npmrc ${HOME}/.npmrc
    if ! cat ${HOME}/.npmrc | grep -q "prefix="; then
        cat <<END >>${HOME}/.npmrc
prefix=\${HOME}/.local
END
    fi
fi
# maven
if [ $(
    command -v mvn >/dev/null
    echo $?
) -eq 0 ]; then
    update_file ${DOTFILES_URL}/maven/settings.xml ${HOME}/.m2/settings.xml
fi
# cargo
if [ $(
    command -v cargo >/dev/null
    echo $?
) -eq 0 ]; then
    update_file ${DOTFILES_URL}/cargo/config.toml ${HOME}/.cargo/config.toml
fi
# powershell
if [ $(
    command -v pwsh >/dev/null
    echo $?
) -eq 0 ]; then
    update_file ${DOTFILES_URL}/powershell/Microsoft.PowerShell_profile.ps1 \
        ${HOME}/.config/powershell/Microsoft.PowerShell_profile.ps1
    update_file ${DOTFILES_URL}/powershell/Microsoft.PowerShell_profile.ps1 \
        ${HOME}/.config/powershell/Microsoft.VSCode_profile.ps1
fi
# sh
if [[ ${SHELL} =~ .*zsh$ ]]; then
    # .zshrc
    if [ ! -f ${HOME}/.zshrc ]; then
        update_file ${DOTFILES_URL}/sh/.zshrc ${HOME}/.zshrc
    fi
    if ! cat ${HOME}/.zshrc | grep -q ".bash_aliases"; then
        cat <<END >>${HOME}/.zshrc

# modify by aggresss
if [ -f \${HOME}/.bash_aliases ]
then
    . \${HOME}/.bash_aliases
fi

END
    fi
    # .zprofile
    if [ ! -f ${HOME}/.zprofile ]; then
        update_file ${DOTFILES_URL}/sh/.zprofile ${HOME}/.zprofile
    fi
    # .zlogout
    if [ ! -f ${HOME}/.zlogout ]; then
        update_file ${DOTFILES_URL}/sh/.zlogout ${HOME}/.zlogout
    fi
    if ! cat ${HOME}/.zlogout | grep -q "ssh-agent -k"; then
        cat <<END >>${HOME}/.zlogout

# modify by aggresss
# ssh-agent
if [ \${SSH_AGENT_PID:-NoDefine} != "NoDefine" ]
then
  eval \`ssh-agent -k\`
fi

END
    fi

elif [[ ${SHELL} =~ .*bash$ ]]; then
    # .bashrc
    if [ ! -f ${HOME}/.bashrc ]; then
        if [ -f /etc/skel/.bashrc ]; then
            cp /etc/skel/.bashrc ${HOME}/
        else
            update_file ${DOTFILES_URL}/sh/.bashrc ${HOME}/.bashrc
        fi
    fi
    if ! cat ${HOME}/.bashrc | grep -q ".bash_aliases"; then
        cat <<END >>${HOME}/.bashrc

# modify by aggresss
if [ -f \${HOME}/.bash_aliases ]
then
    . \${HOME}/.bash_aliases
fi

END
    fi
    # .bash_profile
    if [ ! -f ${HOME}/.bash_profile ]; then
        if [ -f /etc/skel/.bash_profile ]; then
            cp /etc/skel/.bash_profile ${HOME}/
        else
            update_file ${DOTFILES_URL}/sh/.bash_profile ${HOME}/.bash_profile
        fi
    fi
    # .bash_logout
    if [ ! -f ${HOME}/.bash_logout ]; then
        if [ -f /etc/skel/.bash_logout ]; then
            cp /etc/skel/.bash_logout ${HOME}/
        else
            update_file ${DOTFILES_URL}/sh/.bash_logout ${HOME}/.bash_logout
        fi
    fi
    if ! cat ${HOME}/.bash_logout | grep -q "ssh-agent -k"; then
        cat <<END >>${HOME}/.bash_logout

# modify by aggresss
# ssh-agent
if [ \${SSH_AGENT_PID:-NoDefine} != "NoDefine" ]
then
  eval \`ssh-agent -k\`
fi

END
    fi
fi

# Environment Specify
case $(uname) in
Linux)
    update_file ${DOTFILES_URL}/sh/.Xresources ${HOME}/.Xresources
    echo "Linux"
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
