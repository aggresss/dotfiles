#
# bash file for MacOS
# wget https://raw.githubusercontent.com/aggresss/dotfiles/master/home/.bash_profile
#

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# environment for gcc
alias gcc='gcc-7'
alias g++='g++-7'
alias c++='c++-7'

# ls color
export CLICOLOR=1
export LSCOLORS=gxfxaxdxcxegedabagacad

# environment for java
export JAVA_HOME=`/usr/libexec/java_home`
export PATH=$PATH:$JAVA_HOME/bin

# environment for golang
export GOROOT="/usr/local/go/go1.10.2"
export PATH="$PATH:$GOROOT/bin:$HOME/go/bin"
export GOPATH="$HOME/go:$HOME/go-workspace"

# environment for ~/bin
export PATH="$PATH:$HOME/bin"
