#!/usr/bin/env bash

case $(uname) in
    Darwin)
        GLOBAL_WORKSPACE="${HOME}/Library/Application Support/Code/User"
        ;;
    Linux)
        GLOBAL_WORKSPACE="${HOME}/.config/Code/User"
        ;;
    MINGW*)
        GLOBAL_WORKSPACE="%APPDATA%\Code\User"
        ;;
esac

set -v
if [ ! -d "${GLOBAL_WORKSPACE}/snippets/" ]
then
    mkdir -p "${GLOBAL_WORKSPACE}/snippets"
fi
cp ${PWD}/go.json "${GLOBAL_WORKSPACE}/snippets/"
set +v
