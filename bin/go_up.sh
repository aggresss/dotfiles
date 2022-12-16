#!/usr/bin/env bash
# Bash file for golang update
# Author: @aggresss

# viriable for install
BASE_URL="https://golang.google.cn/dl"

if [ ${1:-NOCONFIG} = "NOCONFIG" ]; then
    GO_VERSION=$(curl -q -s -L 'https://golang.google.cn/VERSION?m=text')
else
    GO_VERSION="go$1"
fi

if [ $(command -v go >/dev/null; echo $?) -eq 0 ]; then
    CUR_VERSION=$(go version | awk '{print $3}')
    if [ ${GO_VERSION} = ${CUR_VERSION} ]; then
        echo -e "\nVersion ${CUR_VERSION} is already update\n"
        exit 0
    else
         echo -e "\nUpdate version to ${GO_VERSION}\n"
    fi
fi

###  function for download and extract to assign path ####
# $1 download URL
# $2 local path
function down_load {
    local down_file=$(echo "$1" | awk -F "/" '{print $NF}')
    local file_ext=${down_file##*.}
    if [ $(curl -I -o /dev/null -s -w %{http_code} $1) -ge 400 ]; then
        echo "Query $1 not exist."
        return 1
    fi
    if ! curl -OL $1; then
        echo "Download $1 failed."
        return 2
    fi

    if [ -d $2 ]; then
        rm -rf $2
    fi
    mkdir -p $2

    if [ $file_ext = "gz" -o $file_ext = "bz2" ]; then
        tar -vxf ${down_file} -C $2 --strip-components 1
        rm -rf ${down_file}
    fi
}

if [ ${GOROOT:-NOCONFIG} = "NOCONFIG" ]; then
    INSTALL_DIR=${HOME}/.local/go
else
    INSTALL_DIR="${GOROOT}"
fi

case $(uname) in
    Darwin)
        OS="darwin"
        ;;
    Linux)
        OS="linux"
        ;;
    *)
        echo "Operating system not support."
        exit 1
        ;;
esac

case $(uname -m) in
    x86_64)
        ARCH="amd64"
        ;;
    arm64)
        ARCH="arm64"
        ;;
    *)
        echo "Machine architecture no support."
        exit 1
        ;;
esac

down_load ${BASE_URL}/${GO_VERSION}.${OS}-${ARCH}.tar.gz ${INSTALL_DIR}
