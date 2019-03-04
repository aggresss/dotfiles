#!/usr/bin/env bash
# file .bash_aliases
# start of modify
# modify by aggresss
# wget https://raw.githubusercontent.com/aggresss/dotfiles/master/home/.bash_aliases

##########################
# modify for utility
##########################

# color for echo
BLACK="\\033[30m"
RED="\\033[31m"
GREEN="\\033[32m"
YELLOW="\\033[33m"
BLUE="\\033[34m"
MAGENTA="\\033[35m"
CYAN="\\033[36m"
WHITE="\\033[37m"
NORMAL="\\033[0m"
HIGHLIGHT="\\033[1m"
INVERT="\\033[7m"

# alias for fast command
if [ -f /.dockerenv ]; then
    alias s='cd /mnt/workspace-scratch'
    alias d='cd /mnt/Downloads'
else
    alias s='cd ${HOME}/workspace-scratch'
    alias d='cd ${HOME}/Downloads'
    alias f='cd ${HOME}/workspace-formal'
    alias m='cd ${HOME}/Documents'
    alias v='cd ${HOME}/Vagrant'
fi
# fast update bash env
alias u='source ${HOME}/.bash_aliases'
# git_prompt fast
alias p='git_prompt'
# fast switch to git top level
alias t='git_top'
# fast show git branch
alias b='git branch'
# fast execute file content
alias r='source_file exec'
# fast copy file content
alias c='source_file copy'
# fast edit index note file
alias e='source_file edit'
#fast ssh-agent
alias a='ssh_agent'
alias k='eval `ssh-agent -k`'
alias ak='kill_all ssh-agent'
#fast git status
alias y='git status; git stash list; echo'

# find file
alias fdf='find . -name "*" |grep -sin'
# find file content
alias fdc='find . -name "*" |xargs grep -sin'
# cmake clean
alias cmc='find . -iname "*cmake*" -not -name CMakeLists.txt -exec rm -rf {} +'
# count code line
alias ccl='find . -name "*[.h|.c|.hpp|.cpp|.go|.py]" -type f | xargs cat | wc -l'
# alias for ${LD_LIBRARY_PATH}
alias env_ld_p='echo -e ${RED}LD_LIBRARY_PATH:\\n${GREEN}${LD_LIBRARY_PATH//:/\\n}${NORMAL}'
alias env_ld_i='env_insert LD_LIBRARY_PATH ${PWD}'
alias env_ld_a='env_append LD_LIBRARY_PATH ${PWD}'
alias env_ld_d='env_prune LD_LIBRARY_PATH ${PWD}'
# alias for ${PATH}
alias env_path_p='echo -e ${RED}PATH:\\n${GREEN}${PATH//:/\\n}${NORMAL}'
alias env_path_i='env_insert PATH ${PWD}'
alias env_path_a='env_append PATH ${PWD}'
alias env_path_d='env_prune PATH ${PWD}'
# alias for ${GOPATH}
alias env_go_p='echo -e ${RED}GOPATH:\\n${GREEN}${GOPATH//:/\\n}${NORMAL}'
alias env_go_i='env_insert GOPATH ${PWD}'
alias env_go_a='env_append GOPATH ${PWD}'
alias env_go_d='env_prune GOPATH ${PWD}'
# alias for some application special open
alias enw='emacs -nw'
# alias for remove fast
alias rm_3rd='rm -rvf *.zip *.tgz *.bz2 *.gz *.dmg *.7z *.xz *.tar'
alias rm_mda='rm -rvf *.jpg *.jpeg *.png *.bmp *.gif *.mp3 *.acc *.wav *.mp4 *.flv *.mov *.avi *.ts *.wmv *.mkv'
alias rm_doc='rm -rvf *.doc *.docx *.xls *.xlsx *.ppt *.pptx *.numbers *.pages *.key'
alias rm_ds='rm_rcs .DS_Store'
# short for cd ..
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
# Some more alias to avoid making mistakes
alias rm='rm -i'
alias mv='mv -i'
# Generate GNU standard files
alias make_gnu='touch AUTHORS COPYING ChangeLog NEWS README'

# conversion number
#$1 obase
#$2 ibase
#$3 number
function conv_num()
{
    echo "obase=$1; ibase=$2; $3" | bc
}

# fast ssh-agent
function ssh_agent()
{
    if [ ${SSH_AGENT_PID:-NOCONFIG} = "NOCONFIG" ] || ! ps aux | grep ssh-agent | grep -vq grep; then
        eval `ssh-agent` && ssh-add
    elif ! ssh-add -l > /dev/null 2>&1; then
        ssh-add || eval `ssh-agent` && ssh-add
    else
        echo -e "${YELLOW}SSH_AGENT_PID: ${SSH_AGENT_PID}${NORMAL}"
        ssh-add -l
    fi
}

# kill all
# $1 process name to kill
function kill_all()
{
    local process_id=$(ps ax | grep -e "[/\ ]$1\$" -e "[/\ ]$1[\ ]" | grep -v grep | awk '{print $1}' | sort -u)
    if [ "x$process_id" != "x" ]; then
        for id in $process_id
        do
            kill -9 $id
        done
        echo -e "PID KILLED:\n${RED}${process_id}${NORMAL}"
    fi
}

# search file on $PATH
function find_bin()
{
    echo -e "${GREEN}"
    local tmp_arg
    for i in `seq 1 $#`
    do
        eval tmp_arg=\$$i
        eval find {${PATH//:/,}} -name '${tmp_arg}'
    done
    echo -e "${NORMAL}"
}

# fast decompression archives
function un_ball()
{
    if [ $# -ne 1 ]; then
        echo -e "${RED}Arguments no support.${NORMAL}"
        return 1;
    fi
    if [[ $1 =~ .*\.zip$ ]]; then
        # *.zip
        unzip $1 -d ${1%.zip}
    elif [[ $1 =~ .*\.rar$ ]]; then
        # *.rar
        mkdir -p ${1%.rar}
        unrar x $1 ${1%.rar}
    elif [[ $1 =~ .*\.tar.xz$ ]]; then
        # *.tar.xz
        tar Jvxf $1
    elif [[ $1 =~ .*\.tar.gz$ || $1 =~ .*\.tgz$ ]]; then
        # *.tar.gz or *.tgz
        tar zvxf $1
    elif [[ $1 =~ .*\.tar.bz2$ ]]; then
        # *.tar.bz2
        tar jvxf $1
    elif [[ $1 =~ .*\.tar$ ]]; then
        # *.tar
        tar vxf $1
    else
        echo -e "${RED}Archive tpye no support.${NORMAL}"
    fi
}

# fast source file content
# $1: copy source
# $2: filename or ~/note/* index
# $3-: lines to execute
function source_file()
{
    local index_range=$(ls -1p ${HOME}/note/* 2>/dev/null | sed -n '$=')
    if [ $# -le 1 ]; then
        echo -e ${YELLOW}
        ls -1p ${HOME}/note/* 2>/dev/null | cat -n
        echo -e ${NORMAL}
    else
        # arguments >= 2
        if [ ! -f $2 -a $2 -ge 1 -a $2 -le ${index_range} ] 2>/dev/null; then
            local index_file=$(ls -1p ${HOME}/note/* | sed -n "${2}p")
        else
            local index_file=${2}
        fi
        if [ ! -f ${index_file} ]; then
            echo -e "${RED}\nFile not exist.\n${NORMAL}"
            return 1
        fi
        # edit command
        if [ "$1" = "edit" ]; then
            vim ${index_file}
            return 0
        fi
        # arguments = 2
        if [ $# -eq 2 ]; then
            echo -e ${GREEN}
            cat -n ${index_file}
            echo -e ${NORMAL}
        else
            # arguments > 2
            local tmp_src_file=$(mktemp)
            local i
            for ((i=3; i<=$#; i++))
            do
                eval local line_range=\$\{${i}\}
                if [ "${line_range}" = "@" ]; then
                    line_range="1,$"
                fi
                sed -n "${line_range}p" ${index_file} >> ${tmp_src_file}
                local file_index=$(sed -n '$=' ${tmp_src_file})
            done
            # operate file
            case $1 in
                copy)
                    echo -e ${CYAN}; cat -n ${tmp_src_file}; echo -e ${NORMAL}
                    case $(uname) in
                        Linux)
                            if [ ${file_index} -eq 1 ]; then
                                 cat ${tmp_src_file} | tr -d \\n | xclip -selection clipboard
                            else
                                 cat ${tmp_src_file} | xclip -selection clipboard
                            fi
                            ;;
                        Darwin)
                            if [ ${file_index} -eq 1 ]; then
                                 cat ${tmp_src_file} | tr -d \\n | pbcopy
                            else
                                 cat ${tmp_src_file} | pbcopy
                            fi
                            ;;
                        *)
                            echo -e "${RED}No support this OS.${NORMAL}"
                            ;;
                    esac
                    ;;
                exec)
                    echo -e ${MAGENTA}; cat -n ${tmp_src_file}; echo -e ${NORMAL}
                    source ${tmp_src_file}
                    ;;
                *)
                    echo -e "${RED}No support this command.${NORMAL}"
                    ;;
            esac
            rm -rf ${tmp_src_file}
        fi
    fi
}

# remove recursive
function rm_rcs()
{
    local tmp_arg
    for i in `seq 1 $#`
    do
        eval tmp_arg=\$$i
        echo -e "${RED}CLEAR ==> ${tmp_arg}${NORMAL}"
        find . -name "${tmp_arg}" -exec rm -rvf {} \;
    done
}

# fast find process
# $1 process name
function ps_grep()
{
    ps aux | grep -si $1 | grep -v grep
}

# update file utility
# $1 download url
# $2 local filepath
function update_file()
{
    local tmp_path="/tmp"
    local down_file=`echo "$1" | awk -F "/" '{print $NF}'`
    rm -rf ${tmp_path}/${down_file}
    wget -P ${tmp_path} $1
    cp -f ${tmp_path}/${down_file} $2
    rm -f ${tmp_path}/${down_file}
}

# switch proxy on-off
# $1: port 1-65536; null to display; else to close
function proxy_cfg()
{
    if [ ${1:-NOCONFIG} = "NOCONFIG" ]; then
        if [ -n "${proxy-}" ]; then
            echo -e "${YELLOW}${proxy}${NORMAL}"
        else
            echo -e "${YELLOW}proxy disabled.${NORMAL}"
        fi
        return 0
    fi
    local port=$(echo $1 | sed 's/[^0-9]//g')
    if [ ${port:=0} -gt 0  -a ${port} -lt 65536 ]; then
        if [ -f /.dockerenv ]; then
            local proxy_url="http://host.docker.internal:${port}"
        else
            local proxy_url="http://localhost:${port}"
        fi
        export proxy=${proxy_url}
        export http_proxy=${proxy_url}
        export https_proxy=${proxy_url}
        export ftp_proxy=${proxy_url}
        echo -e "${GREEN}${proxy}${NORMAL}"
    else
        unset proxy http_proxy https_proxy ftp_proxy
        echo -e "${RED}porxy cloesd.${NORMAL}"
    fi
}

# add new element to environment variable append mode
# $1 enviroment variable
# $2 new element
function env_append()
{
    eval local env_var=\$\{${1}\-\}
    local new_element=${2%/}
    if [ -d "$new_element" ] && ! echo $env_var | grep -E -q "(^|:)$new_element($|:)" ; then
        eval export $1="\${$1-}\${$1:+\:}${new_element}"
    fi
}

# add new element to environment variable insert mode
# $1 enviroment variable
# $2 new element
function env_insert()
{
    eval local env_var=\$\{${1}\-\}
    local new_element=${2%/}
    if [ -d "$new_element" ] && ! echo $env_var | grep -E -q "(^|:)$new_element($|:)" ; then
        eval export $1="${new_element}\${$1:+\:}\${$1-}"
    fi
}

# prune element from environment variable
# $1 enviroment variable
# $2 prune element
function env_prune()
{
    eval local env_var=\$\{${1}\-\}
    local del_element=${2%/}
    eval export $1="$(echo ${env_var} | sed -e "s;\(^\|:\)${del_element}\(:\|\$\);\1\2;g" -e 's;^:\|:$;;g' -e 's;::;:;g')"
}


##########################
# modify for vagrant
##########################

# Fast list vagrant status
function vagrant_ps()
{
    command vagrant >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e ${YELLOW}; echo -e "vagrant box list:"
        vagrant box list
        echo -e ${GREEN}; echo -e "vagrant global-status:"
        vagrant global-status
        echo -e ${NORMAL}
    fi

}


##########################
# modify for docker
##########################

# Fast docker inside
function docker_shell()
{
    docker exec -it $1 bash -c "stty cols $COLUMNS rows $LINES && bash";
}

# Inspect volumes and port
function docker_inspect()
{
    echo -e "${GREEN}Volumes:"
    docker inspect --format='{{range .Mounts }}{{println .}}{{end}}' $1
    echo -e "${YELLOW}Ports:"
    docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{$p}} -> {{$conf}}{{println}}{{end}}' $1
    echo -e "${CYAN}Environment:"
    docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' $1
    echo -e "${MAGENTA}Command:"
    docker inspect  --format='{{.Config.Cmd}}' $1
    echo -e "${NORMAL}"
}

# Run and mount private file
function docker_private()
{
    if ! docker volume ls | grep -q root; then
        docker volume create root
    elif ! docker volume ls | grep -q home ; then
        docker volume create home
    fi
    case $(uname) in
        Linux)
            local docker_host=$(docker network inspect --format='{{range .IPAM.Config}}{{.Gateway}}{{end}}' bridge)
            xhost +local:docker > /dev/null
            docker run --rm -it \
                --add-host=host.docker.internal:${docker_host} \
                -v /tmp/.X11-unix/:/tmp/.X11-unix \
                -v root:/root \
                -v home:/home \
                -v ${HOME}/Downloads:/mnt/Downloads \
                -v ${HOME}/workspace-scratch:/mnt/workspace-scratch \
                -e DISPLAY \
                $*
            ;;
        Darwin)
            xhost +localhost > /dev/null
            docker run --rm -it \
                -v root:/root \
                -v home:/home \
                -v ${HOME}/Downloads:/mnt/Downloads \
                -v ${HOME}/workspace-scratch:/mnt/workspace-scratch \
                -e DISPLAY=host.docker.internal:0 \
                $*
            ;;
        *)
            echo "No support OS."
            ;;
    esac
}

# Run private as debug
function docker_debug()
{
    docker_private \
        --cap-add=SYS_PTRACE \
        --security-opt seccomp=unconfined \
        $*
}

# Run private with super privilage
function docker_sudo()
{
    docker_private \
        --privileged \
        $*
}

# killall containers
function docker_kill()
{
    if [ -n "`docker ps -a -q`" ]; then
        docker rm -f `docker ps -a -q`
    fi
}


##########################
# modify for git
##########################

# fast change directry to git top level path
alias git_top='cd `git rev-parse --show-toplevel`'
# fast git diff file status
alias git_diff='git diff --name-status'

# Signature for github repository
# $1 user.email
function git_sig()
{
  git config user.name `echo "$1" | awk -F "@" '{print $1}'`
  git config user.email $1
}

# clone repo in hierarchy directory as site/org/repo
# $1 repo URI
function git_clone()
{
    local clone_path=$1
    # https
    clone_path=${clone_path#*://}
    # ssh
    clone_path=${clone_path#*@}
    clone_path=${clone_path/:/\/}
    # trim .git suffix
    clone_path=${clone_path%.git}
    git clone $@ ${clone_path} && \
    echo -e "\n${GREEN} Clone $1 on ${PWD}/${clone_path} successfully.${NORMAL}\n"
}

# Get pull request to local branch
# $1 remote name
# $2 pull request index No.
function git_pull()
{
    if [ $# != 2 ]; then
        echo -e "${HIGHLIGHT}${RED}Please input remote name and pull request No.${NORMAL}"
        return 1
    fi
    local remote_name=$1
    local remote_pr=$2
    git fetch ${remote_name} pull/${remote_pr}/head:pull/${remote_name}/${remote_pr} && \
    git checkout pull/${remote_name}/${remote_pr}
}

# Delete git branch on local and remote
# $1 git branch
function git_del()
{
    local cur_branch
    local del_remote=0
    for i in `seq 1 $#`
    do
        eval cur_branch=\$$i
        if git branch | grep -q ${cur_branch}; then
            git branch -D ${cur_branch}
        else
            echo -e "${RED}No branch ${cur_branch} on local.${NORMAL}"
            continue
        fi
        if git branch -r | grep -q origin/${cur_branch}; then
            git push origin :${cur_branch}
            del_remote=1
        else
            echo -e "${RED}No branch ${cur_branch} on remote origin.${NORMAL}"
        fi
    done
    if [ ${del_remote} -eq 1 ]; then
        git remote update origin
    fi
}

# Set global gitignore file
function git_ignore()
{
  local base_url="https://raw.githubusercontent.com/aggresss/dotfiles/master"
  update_file ${base_url}/.gitignore ${HOME}/.gitignore
  git config --global core.excludesfile ${HOME}/.gitignore
}

function git_branch_internal()
{
    local dir=. head
    until [ "$dir" -ef / ]; do
        if [ -f "$dir/.git/HEAD" ]; then
            local head=$(< "$dir/.git/HEAD")
                if [[ $head = ref:\ refs/heads/* ]]; then
                    GIT_NAME_TITLE="branch"
                    GIT_NAME_CONTENT="${head#*/*/}"
                elif [[ $head != '' ]]; then
                    local tag=`git describe --always --tags`
                    if [[ $head = $tag* ]]; then
                        GIT_NAME_TITLE="commit"
                    else
                        GIT_NAME_TITLE="tag"
                    fi
                    GIT_NAME_CONTENT=$tag
                else
                    GIT_NAME_TITLE="git"
                    GIT_NAME_CONTENT="unknow"
                fi
            GIT_NAME_LEFT=":("
            GIT_NAME_RIGHT=")"
            return
        fi
        dir="../$dir"
    done
    GIT_NAME_TITLE=''
    GIT_NAME_CONTENT=''
    GIT_NAME_LEFT=''
    GIT_NAME_RIGHT=''
}

# Git branch perception

# color for PS1
black=$'\[\e[1;30m\]'
red=$'\[\e[1;31m\]'
green=$'\[\e[1;32m\]'
yellow=$'\[\e[1;33m\]'
blue=$'\[\e[1;34m\]'
magenta=$'\[\e[1;35m\]'
cyan=$'\[\e[1;36m\]'
white=$'\[\e[1;37m\]'
normal=$'\[\e[m\]'

function git_prompt()
{
    if [ "${PROMPT_COMMAND_BAK-NODEFINE}" = "NODEFINE" ] ; then
        PROMPT_COMMAND_BAK=${PROMPT_COMMAND-}
        PS1_BAK=${PS1-}
        PROMPT_COMMAND="git_branch_internal;${PROMPT_COMMAND-}"
        PS1="$PS1$blue\$GIT_NAME_TITLE\$GIT_NAME_LEFT$red\$GIT_NAME_CONTENT$blue\$GIT_NAME_RIGHT\$ $normal"
    else
        PROMPT_COMMAND=${PROMPT_COMMAND_BAK-}
        PS1=${PS1_BAK-}
        unset PROMPT_COMMAND_BAK PS1_BAK
    fi
}

# Git fast add->commit->fetch->rebase->push ! Deprecated
# $1 operation: rebase
function git_haste()
{
    git_branch_internal;
    if [ -z ${GIT_NAME_TITLE} ]; then
        echo -e "${RED}Not in a git repo${NORMAL}"
    elif [ ${GIT_NAME_TITLE} = "branch" ]; then
        echo -e "${CYAN}add->push->commit to origin on branch ${YELLOW}${GIT_NAME_CONTENT}${NORMAL}"
        git commit -m "`date "+%F %T %Z W%WD%u"`"
        if [ X_$1 == "X_commit" ]; then
            return 0
        fi
        if [ X_$1 == "X_rebase" ]; then
            echo -e "${GREEN}fetch->rebase to origin on branch ${MAGENTA}${GIT_NAME_CONTENT}${NORMAL}"
            git fetch origin
            git rebase origin/${GIT_NAME_CONTENT}
        fi
        git push origin ${GIT_NAME_CONTENT}:${GIT_NAME_CONTENT}
    else
        echo -e "${MAGENTA}Not on a regular branch${NORMAL}"
    fi
}

# Git fast download file from url
# $1 url
function git_down()
{
    local url=$1
    local vendor=$(echo "${url}" | awk -F'[/:]' '{print $4}')
    local uri=$(echo "${url}" | cut -d/ -f4-)
    local user=$(echo "${uri}" | cut -d/ -f1)
    local repo=$(echo "${uri}" | cut -d/ -f2)
    local branch=$(echo "${uri}" | cut -d/ -f4)
    local path=$(echo "${uri}" | cut -d/ -f5-)

    if [[ -z ${url} || -z ${vendor} || -z ${uri} || -z ${user} || -z ${repo} || -z ${branch} || -z ${path} ]]; then
        echo -e "Invalid URL: $1"
        return 1
    fi

    case ${vendor} in
        gitlab.com | github.com)
            wget https://${vendor}/${user}/${repo}/raw/${branch}/${path}
            ;;
        *)
            echo -e "Not support URL: $1"
            echo -e "Maybe: https://${vendor}/${user}/${repo}/raw/${branch}/${path}"
            ;;
    esac
}

##########################
# modify for Golang
##########################

# environmnet for Golang
if [ -d "$HOME/.local/go" ]; then
    export GOROOT="$HOME/.local/go"
    env_insert "PATH" "$GOROOT/bin"
fi

if [ -d "$HOME/go" ];then
    env_insert "GOPATH" "$HOME/go"

    if [ ! -d "$HOME/go/bin" ]; then
        mkdir -p $HOME/go/bin
    fi
    env_insert "PATH" "$HOME/go/bin"
fi

GOPATH_BAK=${GOPATH-}

# reset $GOPATH
function go_reset()
{
    export GOPATH=${GOPATH_BAK-}
    echo -e "${GREEN}successful clear GOPATH \n${RED}GOPATH ==> ${GOPATH}${NORMAL}"
}

# set $PWD to $GOPATH
function go_pwd()
{
    if [[ ${GOPATH-} =~ .*$PWD.* ]]; then
        echo -e "${RED}currnet dir is already in GOPATH${NORMAL}"
    else
        export GOPATH=${PWD}
        echo -e "${GREEN}successful set GOPATH \n${RED}GOPATH ==> ${GOPATH}${NORMAL}"
    fi
}


##########################
# specified
##########################

# specified for ${HOME}/.local/bin
if [ ! -d ${HOME}/.local/bin ]; then
    mkdir -p ${HOME}/.local/bin
fi
env_append "PATH" "${HOME}/.local/bin"

# environment for ~/bin
env_append "PATH" "${HOME}/bin"

# specified for system type
echo -e "${GREEN}ENV: $(uname)${NORMAL}"
case $(uname) in
    Darwin)
        # ls colours
        export CLICOLOR=1
        export LSCOLORS=ExGxFxDxCxegedabagacad
        # environment for gcc
        alias gcc='gcc-7'
        alias g++='g++-7'
        alias c++='c++-7'
        # environment for java
        export JAVA_HOME=`/usr/libexec/java_home`
        env_append "PATH" "$JAVA_HOME/bin"
        # wine chinese character
        alias wine='env LANG=zh_CN.UTF8 wine'
        # use "brew install gnu-sed" instead of bsd-sed
        alias sed='gsed'
        alias awk='gawk'
        alias tar='gtar'
        alias find='gfind'
        ;;
    Linux)
        release_info=$(uname -r | awk -F'-' '{print $NF}')
        # specified for docker container
        if [ -f /.dockerenv ]; then
            echo -e "${YELLOW}DOCKER_IMAGE: ${DOCKER_IMAGE}${NORMAL}"
            if [ "${release_info}" = "linuxkit" ]; then
                echo -e "${CYAN}HOST: ${release_info}${NORMAL}"
            fi
        fi
        # Specified for Microsoft WSL
        if [ "${release_info}" = "Microsoft" ]; then
            echo -e "${CYAN}HOST: ${release_info}${NORMAL}"
            export DISPLAY=localhost:0
        fi
        # Specified for Gnome environment
        if [ $(command -v gnome-terminal >/dev/null; echo $?) -eq 0 ]; then
            alias cbp='chromium-browser --proxy-server=socks5://127.0.0.1:1080'
            alias calc='gnome-calculator'
            alias gterm='gnome-terminal'
        fi
        alias cb='cmake_build.sh'
        alias ab='autotools_build.sh'
        alias vmc='valgrind --tool=memcheck --leak-check=yes --track-fds=yes --trace-children=yes --show-reachable=yes --error-exitcode=255'
        ;;
    FreeBSD)
        # ls colours
        export CLICOLOR=1
        export LSCOLORS=ExGxFxDxCxegedabagacad
        ;;
    MINGW*)
        ;;
    *)
        echo "No support this ENV."
        ;;
esac


# end of .bash_aliases

