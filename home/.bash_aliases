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

# environment for ~/bin
export PATH="$PATH:$HOME/bin"

# find file
alias fdf='find . -name "*" |grep -sin'
# find file content
alias fdc='find . -name "*" |xargs grep -sin'
# cmake clean
alias cmc='find . -iname "*cmake*" -not -name CMakeLists.txt -exec rm -rf {} +'
# count code line
alias ccl='find . -name "*[.h|.c|.hpp|.cpp|.go|.py]" -type f | xargs cat | wc -l'
# alias for some application special open
alias calc='gnome-calculator'
alias gterm='gnome-terminal'
alias em='emacs -nw'
alias cbp='chromium-browser --proxy-server=socks5://127.0.0.1:1080'
alias wine='env LANG=zh_CN.UTF8 wine'
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
function rm_rcs()
{
    for i in `seq 1 $#`
    do
        eval TMP_ARG=\$$i
        echo -e "${RED}CLEAR ==> ${TMP_ARG}${NORMAL}"
        find . -name "${TMP_ARG}" -exec rm -rvf {} \;
    done
}
export rm_rcs

# update file utility
# $1 download url
# $2 local filepath
function update_file()
{
    TMP_PATH="/tmp"
    DOWN_FILE=`echo "$1" | awk -F "/" '{print $NF}'`
    rm -rf ${TMP_PATH}/${DOWN_FILE}
    wget -P ${TMP_PATH} $1
    cp -f ${TMP_PATH}/${DOWN_FILE} $2
    rm -f ${TMP_PATH}/${DOWN_FILE}
}
export -f update_file

# switch proxy on-off
proxy_cfg(){
  if [ $1 == 1 ]; then
    proxy_url="http://127.0.0.1:8123"
    export proxy=${proxy_url}
    export http_proxy=${proxy_url}
    export https_proxy=${proxy_url}
    export ftp_proxy=${proxy_url}
  elif [ $1 == 0 ]; then
    unset proxy http_proxy https_proxy ftp_proxy
    fi
}
export -f proxy_cfg


##########################
# modify for docker
##########################

# Fast docker inside
docker_inside(){
  docker exec -it $1 bash -c "stty cols $COLUMNS rows $LINES && bash";
}
export -f docker_inside

# Inspect volumes and port
docker_inspect(){
  echo "Volumes:" ; docker inspect $1 -f {{.Config.Volumes}}
  echo "ExposedPorts:" ; docker inspect $1 -f {{.Config.ExposedPorts}}
  echo "Labels:" ; docker inspect $1 -f {{.Config.Labels}}
}
export -f docker_inspect

# Run and mount private file
docker_private(){
  docker run --rm -it \
    -v root:/root \
    -v ~/Downloads:/Downloads \
    $*
}
export -f docker_private

##########################
# modify for git
##########################

# Signature for github repository
# $1 user.email
git_sig(){
  git config user.name `echo "$1" | awk -F "@" '{print $1}'`
  git config user.email $1
}
export -f git_sig

# Set global gitignore file
git_ignore(){
  BASE_URL="https://raw.githubusercontent.com/aggresss/dotfiles/master"
  update_file ${BASE_URL}/.gitignore ${HOME}/.gitignore
  git config --global core.excludesfile ${HOME}/.gitignore
}
export -f git_ignore

git_branch_internal(){
    local dir=. head
    until [ "$dir" -ef / ]; do
        if [ -f "$dir/.git/HEAD" ]; then
            head=$(< "$dir/.git/HEAD")
                if [[ $head = ref:\ refs/heads/* ]]; then
                    git_branch="${head#*/*/}"
                elif [[ $head != '' ]]; then
                    git_branch="detached"
                else
                    git_branch="unknow"
                fi
                git_name_left="git:("
                git_name_right=")"
                return
            fi
        dir="../$dir"
    done
    git_branch=''
    git_name_left=""
    git_name_right=""
}
export -f git_branch_internal

# Git branch perception
git_prompt(){
    PCBAK="/tmp/PROMPT_COMMAND.tmp"
    PSBAK="/tmp/PS1.tmp"
    if [ ! -n "$1" ]; then
        echo "usage: git_prompt on | off"
    elif [ $1 == "on" ]; then
        if [ ! -f $PCBAK ]; then
            echo $PROMPT_COMMAND > $PCBAK
        fi
        if [ ! -f $PSBAK ]; then
            echo $PS1 > $PSBAK
        fi
        if [ -z $GIT_PROMPT ] ; then
            PROMPT_COMMAND="git_branch_internal; $PROMPT_COMMAND"
            PS1="$PS1$blue\$git_name_left$red\$git_branch$blue\$git_name_right\$ $normal"
            export GIT_PROMPT=1
        fi
    elif [ $1 == "off" ]; then
        if [ -f $PCBAK ]; then
            PROMPT_COMMAND="`cat $PCBAK`"
        fi
        if [ -f $PSBAK ]; then
            PS1="`cat $PSBAK` "
        fi
        if [ -n $GIT_PROMPT ]; then
            unset GIT_PROMPT
        fi
    fi
}
export -f git_prompt

# Git fast add->commit->fetch->rebase->push ! Deprecated
git_haste(){
git add .
git commit -m "`date "+%F %T %Z W%WD%u"`"
git fetch origin
git rebase origin/master
git push origin master
}
export -f git_haste
##########################
# modify for golang
##########################

# environmnet for Golang
if [ -d "$HOME/.local/go" ]; then
    export GOROOT="$HOME/.local/go"
    export PATH="$GOROOT/bin:$PATH"
fi

if [ -d "$HOME/go" ];then
    if [ -z "$GOPATH" ]; then
        export GOPATH="$HOME/go"
    else
        export GOPATH="$HOME/go:$GOPATH"
    fi

    if [ ! -d "$HOME/go/bin" ]; then
        mkdir -p $HOME/go/bin
    fi
    export PATH="$HOME/go/bin:$PATH"
fi

GOPATH_INIT_PATH="/tmp/GOPATH_INIT.tmp"
if [ ! -f "$GOPATH_INIT_PATH" ]; then
    echo $GOPATH > $GOPATH_INIT_PATH
fi

# clear $GOPATH
go_clr(){
    if [ -f "$GOPATH_INIT_PATH" ]; then
        export GOPATH="`cat $GOPATH_INIT_PATH`"
        echo -e "${GREEN}successful clear GOPATH \n${RED}GOPATH ==> ${GOPATH}${NORMAL}"
    fi
}
export -f go_clr

# set $PWD to $GOPATH
go_pwd(){
    if [[ $GOPATH =~ .*$PWD.* ]]; then
        echo -e "${RED}currnet dir is already in GOPATH${NORMAL}"
    else
        export GOPATH=${PWD}
        echo -e "${GREEN}successful set GOPATH \n${RED}GOPATH ==> ${GOPATH}${NORMAL}"
    fi
}
export -f go_pwd

# echo $GOPATH
go_ls(){
    echo -e "${GREEN}GOPATH ===> ${RED}${GOPATH}${NORMAL}"
}
export -f go_ls

##########################
# specified for system type
##########################
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
        export PATH=$PATH:$JAVA_HOME/bin

    ;;
    Linux)

    ;;
    *)

    ;;
esac


# end of .bash_aliases
