# file .bash_aliases
# start of modify
# modify by aggresss
# wget https://raw.githubusercontent.com/aggresss/dotfiles/master/home/.bash_aliases

##########################
# modify for utility
##########################

# color configuration
black=$'\[\e[1;30m\]'
red=$'\[\e[1;31m\]'
green=$'\[\e[1;32m\]'
yellow=$'\[\e[1;33m\]'
blue=$'\[\e[1;34m\]'
magenta=$'\[\e[1;35m\]'
cyan=$'\[\e[1;36m\]'
white=$'\[\e[1;37m\]'
normal=$'\[\e[m\]'

BLACK="\\033[30m"
RED="\\033[31m"
GREEN="\\033[32m"
YELLOW="\\033[33m"
BLUE="\\033[34m"
MAGENTA="\\033[35m"
CYAN="\\033[36m"
WHITE="\\033[37m"
NORMAL="\\033[m"

# alias for fast command
alias s='cd ${HOME}/workspace-scratch'
alias f='cd ${HOME}/workspace-formal'

# find file
alias fdf='find . -name "*" |grep -sin'
# find file content
alias fdc='find . -name "*" |xargs grep -sin'
# cmake clean
alias cmc='find . -iname "*cmake*" -not -name CMakeLists.txt -exec rm -rf {} +'
# count code line
alias ccl='find . -name "*[.h|.c|.hpp|.cpp|.go|.py]" -type f | xargs cat | wc -l'
# echo ${PATH}
alias envp='echo -e ${RED}PATH:\\n${GREEN}${PATH//:/\\n}${NORMAL}'

# alias for some application special open
alias em='emacs -nw'
alias sagt='eval `ssh-agent`'

# alias for remove fast
alias rm_3rd='rm -rvf *.zip *.tgz *.bz2 *.gz *.dmg *.7z *.xz *.tar'
alias rm_mda='rm -rvf *.jpg *.jpeg *.png *.bmp *.gif *.mp3 *.acc *.wav *.mp4 *.flv *.mov *.avi *.ts *.wmv *.mkv'
alias rm_doc='rm -rvf *.doc *.docx *.xls *.xlsx *.ppt *.pptx *.numbers *.pages *.key'

# short for cd ..
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Some more alias to avoid making mistakes
alias rm='rm -i'
alias mv='mv -i'

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
alias rm_ds='rm_rcs .DS_Store'

# fast find process
# $1 process name
function ps_grep()
{
    ps aux | grep -sin $1 | grep -v grep
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
    if [ ${1:-NoDefine} = "NoDefine" ]; then
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
alias enva='env_insert PATH $PWD'

# prune element from environment variable
# $1 enviroment variable
# $2 prune element
function env_prune()
{
    eval local env_var=\$\{${1}\-\}
    eval export $1="$(echo $env_var | sed -e "s;\(^\|:\)${2%/}\(:\|\$\);\1\2;g" -e 's;^:\|:$;;g' -e 's;::;:;g')"
}
alias envd='env_prune PATH $PWD'

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
    xhost + localhost > /dev/null
    if ! docker volume ls | grep -q root; then
        docker volume create root
    elif ! docker volume ls | grep -q home ; then
        docker volume create home
    fi
    docker run --rm -it \
        -v root:/root \
        -v home:/home \
        -v ${HOME}/Downloads:/mnt/Downloads \
        -v ${HOME}/workspace-scratch:/mnt/workspace-scratch \
        -e DISPLAY=host.docker.internal:0 \
        $*
}

# killall containers
function docker_kill()
{
    if [ -n "`docker ps -a -q`" ]; then
        docker rm -f `docker ps -a -q`
    fi
}

# display docker images
function docker_ls()
{
    if [ -n "${DOCKER_IMAGE-}" ]; then
        echo -e "${GREEN}${DOCKER_IMAGE}${NORMAL}"
    else
        echo -e "${RED}Not support this image.${NORMAL}"
    fi
}


##########################
# modify for git
##########################

# fast change directry to git top level path
alias git_top='cd `git rev-parse --show-toplevel`'

# Signature for github repository
# $1 user.email
function git_sig()
{
  git config user.name `echo "$1" | awk -F "@" '{print $1}'`
  git config user.email $1
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
function git_prompt()
{
    local pcbak="/tmp/PROMPT_COMMAND.tmp"
    local psbak="/tmp/PS1.tmp"
    if [ ! -n "$1" ]; then
        echo "usage: git_prompt on | off"
    elif [ $1 == "on" ]; then
        if [ ! -f $pcbak ]; then
            echo ${PROMPT_COMMAND-} > $pcbak
        fi
        if [ ! -f $psbak ]; then
            echo $PS1 > $psbak
        fi
        if [ -z ${GIT_PROMPT-} ] ; then
            PROMPT_COMMAND="git_branch_internal;${PROMPT_COMMAND-}"
            PS1="$PS1$blue\$GIT_NAME_TITLE\$GIT_NAME_LEFT$red\$GIT_NAME_CONTENT$blue\$GIT_NAME_RIGHT\$ $normal"
            export GIT_PROMPT=1
        fi
    elif [ $1 == "off" ]; then
        if [ -f $pcbak ]; then
            PROMPT_COMMAND="`cat $pcbak`"
        fi
        if [ -f $psbak ]; then
            PS1="`cat $psbak` "
        fi
        if [ -n ${GIT_PROMPT-} ]; then
            unset GIT_PROMPT
        fi
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

GOPATH_INIT_PATH="/tmp/GOPATH_INIT.tmp"
if [ ! -f "$GOPATH_INIT_PATH" ]; then
    echo ${GOPATH-} > $GOPATH_INIT_PATH
fi

# clear $GOPATH
function go_clr()
{
    if [ -f "$GOPATH_INIT_PATH" ]; then
        export GOPATH="`cat $GOPATH_INIT_PATH`"
        echo -e "${GREEN}successful clear GOPATH \n${RED}GOPATH ==> ${GOPATH}${NORMAL}"
    fi
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

# echo $GOPATH
function go_ls()
{
    echo -e "${RED}GOPATH:\n${GREEN}${GOPATH//:/\\n}${NORMAL}"
}

##########################
# specified
##########################

# specified for ${HOME}/.local/bin
if [ ! -d ${HOME}/.local/bin ]; then
    mkdir -p ${HOME}/.local/bin
fi
env_append "PATH" "${HOME}/.local/bin"

# specified for docker container
if [ -f /.dockerenv ]; then
    echo ${DOCKER_IMAGE}
fi

# environment for ~/bin
env_append "PATH" "${HOME}/bin"

# specified for system type
case $(uname) in
    Darwin)
        # ls color
        export CLICOLOR=1
        export LSCOLORS=gxfxaxdxcxegedabagacad
        # environment for gcc
        alias gcc='gcc-7'
        alias g++='g++-7'
        alias c++='c++-7'
        # environment for java
        export JAVA_HOME=`/usr/libexec/java_home`
        env_append "PATH" "$JAVA_HOME/bin"
        # wine chinese character
        alias wine='env LANG=zh_CN.UTF8 wine'

    ;;
    Linux)
        # alias for access easy in Gnome environment
        alias cbp='chromium-browser --proxy-server=socks5://127.0.0.1:1080'
        alias calc='gnome-calculator'
        alias gterm='gnome-terminal'

    ;;
    *)

    ;;
esac


# end of .bash_aliases
