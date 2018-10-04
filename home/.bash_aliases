# file .bash_aliases
# start of modify
# modify by aggresss
# wget https://raw.githubusercontent.com/aggresss/dotfiles/master/home/.bash_aliases

##########################
# modify for utility
##########################

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

# modify bash font color value
# usage: cv 0-6 RGY BMC
colorv(){
  echo -e "\e[0;3${1}m"
}
export -f colorv

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
git-sig(){
  git config user.name  "aggresss"
  git config user.email "aggress@gmail.com"
}
export -f git-sig


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
