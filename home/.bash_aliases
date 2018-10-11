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

# environment for ~/bin
export PATH="$PATH:$HOME/bin"

# find file
alias fdf='find . -name "*" |grep -sin'
# find file content
alias fdc='find . -name "*" |xargs grep -sin'

# count code line
alias ccl='find . -name "*[.h|.c|.hpp|.cpp|.go|.py]" -type f | xargs cat | wc -l'

# alias for some application special open
alias calc='gnome-calculator'
alias gterm='gnome-terminal'
alias em='emacs -nw'
alias cbp='chromium-browser --proxy-server=socks5://127.0.0.1:1080'
alias wine='env LANG=zh_CN.UTF8 wine'

# short for cd ..
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Some more alias to avoid making mistakes
alias rm='rm -i'
alias mv='mv -i'

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
proxy-cfg(){
  if [ $1 == 1 ];then
    proxy_url="http://127.0.0.1:8123"
    export proxy=${proxy_url}
    export http_proxy=${proxy_url}
    export https_proxy=${proxy_url}
    export ftp_proxy=${proxy_url}
  elif [ $1 == 0 ];then
    unset proxy http_proxy https_proxy ftp_proxy
    fi
}
export -f proxy-cfg


##########################
# modify for docker
##########################

# fast docker inside
docker-inside(){
  docker exec -it $1 bash -c "stty cols $COLUMNS rows $LINES && bash";
}
export -f docker-inside

# inspect volumes and port
docker-inspect(){
  echo "Volumes:" ; docker inspect $1 -f {{.Config.Volumes}}
  echo "ExposedPorts:" ; docker inspect $1 -f {{.Config.ExposedPorts}}
  echo "Labels:" ; docker inspect $1 -f {{.Config.Labels}}
}
export -f docker-inspect

# run and mount private file
docker-private(){
  docker run --rm -it \
    -v root:/root \
    -v ~/Downloads:/Downloads \
    $*
}
export -f docker-private

##########################
# modify for git
##########################

# signature for github repository
# $1 user.email
git-sig(){
  git config user.name `echo "$1" | awk -F "@" '{print $1}'`
  git config user.email $1
}
export -f git-sig

# set global gitignore file
git-ignore(){
  BASE_URL="https://raw.githubusercontent.com/aggresss/dotfiles/master"
  update_file ${BASE_URL}/.gitignore ${HOME}/.gitignore
  git config --global core.excludesfile ${HOME}/.gitignore
}
export -f git-ignore

git-branch(){
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
export -f git-branch

git-prompt(){
    PCBAK="/tmp/PROMPT_COMMAND.tmp"
    PSBAK="/tmp/PS1.tmp"
if [ ! -n "$1" ];then
    echo "usage: git-prompt on | off"
elif [ $1 == "on" ];then
    echo $PROMPT_COMMAND > $PCBAK
    echo $PS1 > $PSBAK
    PROMPT_COMMAND="git-branch; $PROMPT_COMMAND"
    PS1="$green->$cyan$PS1$blue\$git_name_left$red\$git_branch$blue\$git_name_right\$$normal"
elif [ $1 == "off" ];then
    if [ -f $PCBAK ];then
        PROMPT_COMMAND=`cat $PCBAK`
    fi
    if [ -f $PSBAK ];then
        PS1=`cat $PSBAK`
    fi
fi
}


##########################
# modify for golang
##########################

# set $PWD append to $GOPATH
gopath-pwd(){
  if [[ $GOPATH =~ .*$PWD.* ]];then
    echo "currnet dir is already in GOPATH"
  else
    export GOPATH=$GOPATH:$PWD
    echo "fininsh setting $PWD in GOPATH"
  fi
}
export -f gopath-pwd

# environmnet for Golang
export GOROOT="$HOME/.local/go"
if [ -d "$GOROOT/bin" ] ; then
    export PATH="$GOROOT/bin:$PATH"
fi

export GOPATH="$GOPATH:$HOME/go"
if [ -d "$GOPATH/bin" ] ; then
    export PATH="$GOPATH/bin:$PATH"
fi

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
