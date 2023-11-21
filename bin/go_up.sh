#!/usr/bin/env bash
# Bash file for golang update
# Author: @aggresss

# viriable for install
BASE_URL="https://golang.google.cn/dl"
UPDATE_GO_VERSION=""
DISCARD_GO_VERSION=""

if [ ${1:-NOCONFIG} = "NOCONFIG" ] || [ $1 == "_" ]; then
    UPDATE_GO_VERSION=$(echo `curl -q -s -L 'https://golang.google.cn/VERSION?m=text'` | awk '{print $1}')
else
    UPDATE_GO_VERSION="go$1"
fi

if [ $(echo ${UPDATE_GO_VERSION} | grep -q -E  'go[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'; echo $?) -ne 0 ]; then
    echo -e "\nnot support go version: ${UPDATE_GO_VERSION}\n"
    exit 1
fi

if [ ${2:-NOCONFIG} != "NOCONFIG" ]; then
    DISCARD_GO_VERSION="go$2"
    if [ $(echo ${DISCARD_GO_VERSION} | grep -q -E  'go[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'; echo $?) -ne 0 ]; then
        echo -e "\nnot support go version: ${DISCARD_GO_VERSION}\n"
        exit 1
    fi
fi

if [ $(command -v go >/dev/null; echo $?) -eq 0 ]; then
    CUR_VERSION=$(go version | awk '{print $3}')
    if [ ${UPDATE_GO_VERSION} = ${CUR_VERSION} ]; then
        echo -e "\nversion ${CUR_VERSION} is already updated.\n"
        exit 0
    elif [ -L ${GOROOT} ] && [ -d `dirname ${GOROOT}`/${UPDATE_GO_VERSION} ]; then
        rm -f ${GOROOT} && ln -s `dirname ${GOROOT}`/${UPDATE_GO_VERSION} ${GOROOT}
        echo -e "\nversion ${UPDATE_GO_VERSION} is already cached. link go version to specified version already.\n"
        exit 0
    else
        echo -e "\nupdate version to ${UPDATE_GO_VERSION}\n"
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
        if [ `echo $?` -ne 0 ]; then
            rm -rf ${down_file}
            rm -rf $2
            echo "Extract $1 failed."
            return 3
        fi
        rm -rf ${down_file}
    fi
    return 0
}

if [ ${GOROOT:-NOCONFIG} = "NOCONFIG" ]; then
    INSTALL_DIR=${HOME}/.local/go
else
    if [ -L ${GOROOT} ]; then
        INSTALL_DIR="`dirname ${GOROOT}`/${UPDATE_GO_VERSION}"
    else
        INSTALL_DIR="${GOROOT}"
    fi
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

down_load ${BASE_URL}/${UPDATE_GO_VERSION}.${OS}-${ARCH}.tar.gz ${INSTALL_DIR}

if [ `echo $?` -eq 0 ] && [ ! -z ${GOROOT} ] && [ -L ${GOROOT} ]; then
    rm -f ${GOROOT} && ln -s ${INSTALL_DIR} ${GOROOT} && go version
    if [ ! -z ${DISCARD_GO_VERSION} ]; then
        if [ -d `dirname ${GOROOT}`/${DISCARD_GO_VERSION} ]; then
            echo "remove obsolate version ${DISCARD_GO_VERSION}"
            rm -rf `dirname ${GOROOT}`/${DISCARD_GO_VERSION}
        fi
    fi
fi
