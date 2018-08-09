
# usage: cp /etc/skel/.bashrc ~/ && cat .bashrc >> ~/.bashrc && source ~/.bashrc
# start of modify
# modify by aggresss

# find file
alias fdf='find . -name "*" |grep -sin'
# find file content
alias fdc='find . -name "*" |xargs grep -sin'

# alias for some application special open
alias calc='gnome-calculator'
alias gterm='gnome-terminal'
alias em='emacs -nw'
alias cbp='chromium-browser --proxy-server=socks5://127.0.0.1:10080'
alias wine='env LANG=zh_CN.UTF8 wine'

# short for cd ..
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# switch proxy on-off
proxy-cfg(){
  if [ $1 == 1 ];then
    proxy_url="http://127.0.0.1:1080"
    export proxy=${proxy_url}
    export http_proxy=${proxy_url}
    export https_proxy=${proxy_url}
    export ftp_proxy=${proxy_url}
  elif [ $1 == 0 ];then
    unset proxy http_proxy https_proxy ftp_proxy
    fi
}
export -f proxy-cfg

# Shadowsocks
alias ssl='sslocal -c /etc/shadowsocks/config-client.json -d'
alias sss='ssserver -c /etc/shadowsocks/config-server.json -d'

# modify for docker
docker-inside(){
  docker exec -it $1 bash -c "stty cols $COLUMNS rows $LINES && bash";
}
export -f docker-inside

docker-inspect(){
  docker inspect $1 | jq -r '.[0].ContainerConfig.Volumes'
  docker inspect $1 | jq -r '.[0].ContainerConfig.ExposedPorts'
}
export -f docker-inspect

# modify bash font color value
# usage: cv 0-6 RGY BMC
colorv(){
  echo -e "\e[0;3${1}m"
}
export -f colorv

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

export GOPATH="$HOME/go"
if [ -d "$GOPATH/bin" ] ; then
    export PATH="$GOPATH/bin:$PATH"
fi


# end of modify
