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

# find file
alias fdf='find . -name "*" |grep -sin'
# find file content
alias fdc='find . -name "*" |xargs grep -sin'
# cmake clean
alias cmc='find . -iname "*cmake*" -not -name CMakeLists.txt -exec rm -rf {} +'
# count code line
alias ccl='find . -name "*[.h|.c|.hpp|.cpp|.go|.py]" -type f | xargs cat | wc -l'
# alias for some application special open
alias em='emacs -nw'
alias sagt='eval `ssh-agent`'

# alias for remove fast
alias rm_3rd='rm -rvf *.zip *.tgz *.bz2 *.gz *.dmg *.7z *.xz *.tar'
alias rm_pic='rm -rvf *.jpg *.jpeg *.png *.bmp *.gif'
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
rm_rcs()
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
ps_grep()
{
    ps aux | grep -sin $1 | grep -v grep
}

# update file utility
# $1 download url
# $2 local filepath
update_file()
{
    local tmp_path="/tmp"
    local down_file=`echo "$1" | awk -F "/" '{print $NF}'`
    rm -rf ${tmp_path}/${down_file}
    wget -P ${tmp_path} $1
    cp -f ${tmp_path}/${down_file} $2
    rm -f ${tmp_path}/${down_file}
}

# switch proxy on-off
proxy_cfg(){
  if [ $1 == 1 ]; then
    local proxy_url="http://127.0.0.1:8123"
    export proxy=${proxy_url}
    export http_proxy=${proxy_url}
    export https_proxy=${proxy_url}
    export ftp_proxy=${proxy_url}
  elif [ $1 == 0 ]; then
    unset proxy http_proxy https_proxy ftp_proxy
    fi
}

# add new element to environment variable append mode
# $1 enviroment variable
# $2 new element
env_append() {
    eval local env_var=\$\{${1}\-\}
    local new_element=${2%/}
    if [ -d "$new_element" ] && ! echo $env_var | grep -E -q "(^|:)$new_element($|:)" ; then
        eval export $1="\${$1-}\${$1:+\:}${new_element}"
    fi
}

# add new element to environment variable insert mode
# $1 enviroment variable
# $2 new element
env_insert() {
    eval local env_var=\$\{${1}\-\}
    local new_element=${2%/}
    if [ -d "$new_element" ] && ! echo $env_var | grep -E -q "(^|:)$new_element($|:)" ; then
        eval export $1="${new_element}\${$1:+\:}\${$1-}"
    fi
}

# prune element from environment variable
# $1 enviroment variable
# $2 prune element
env_prune() {
    eval local env_var=\$\{${1}\-\}
    eval $1="$(echo $env_var | sed -e "s;\(^\|:\)${2%/}\(:\|\$\);\1\2;g" -e 's;^:\|:$;;g' -e 's;::;:;g')"
}


##########################
# modify for docker
##########################

# Fast docker inside
docker_inside(){
  docker exec -it $1 bash -c "stty cols $COLUMNS rows $LINES && bash";
}

# Inspect volumes and port
docker_inspect(){
  echo "Volumes:" ; docker inspect $1 -f {{.Config.Volumes}}
  echo "ExposedPorts:" ; docker inspect $1 -f {{.Config.ExposedPorts}}
  echo "Labels:" ; docker inspect $1 -f {{.Config.Labels}}
}

# Run and mount private file
docker_private(){
    if [ ! "$(docker volume ls | grep root)" ]; then
        docker volume create root
    fi
    docker run --rm -it \
        -v root:/root \
        -v ${HOME}/Downloads:/root/Downloads \
        $*
}

# Run x11 apps in docker container
docker_x11(){
    if [ ! "$(docker volume ls | grep home)" ]; then
        docker volume create home
    fi
    docker run -it \
        -v home:/home \
        -v ${HOME}/Downloads:/home/aggresss/Downloads \
        -e DISPLAY=host.docker.internal:0
        $*
}

##########################
# modify for git
##########################

# fast change directry to git top level path
alias git_top='cd `git rev-parse --show-toplevel`'

# Signature for github repository
# $1 user.email
git_sig(){
  git config user.name `echo "$1" | awk -F "@" '{print $1}'`
  git config user.email $1
}

# Set global gitignore file
git_ignore(){
  local base_url="https://raw.githubusercontent.com/aggresss/dotfiles/master"
  update_file ${base_url}/.gitignore ${HOME}/.gitignore
  git config --global core.excludesfile ${HOME}/.gitignore
}

git_branch_internal(){
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
git_prompt(){
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
git_haste(){
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
go_clr(){
    if [ -f "$GOPATH_INIT_PATH" ]; then
        export GOPATH="`cat $GOPATH_INIT_PATH`"
        echo -e "${GREEN}successful clear GOPATH \n${RED}GOPATH ==> ${GOPATH}${NORMAL}"
    fi
}

# set $PWD to $GOPATH
go_pwd(){
    if [[ ${GOPATH-} =~ .*$PWD.* ]]; then
        echo -e "${RED}currnet dir is already in GOPATH${NORMAL}"
    else
        export GOPATH=${PWD}
        echo -e "${GREEN}successful set GOPATH \n${RED}GOPATH ==> ${GOPATH}${NORMAL}"
    fi
}

# echo $GOPATH
go_ls(){
    echo -e "${GREEN}GOPATH ===> ${RED}${GOPATH}${NORMAL}"
}

##########################
# specified
##########################

# environment for ~/bin
env_insert "PATH" "$HOME/bin"

# specified for system type
SYS_TYPE=`uname`
case ${SYS_TYPE} in
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
