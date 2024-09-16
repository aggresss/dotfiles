#!/usr/bin/env bash
# Bash file for link elementary
# Author: @aggresss

for file in /mnt/*; do
    if [ -L ${HOME}/`basename $file` ]; then
        rm -f ${HOME}/`basename $file`
    fi
    ln -s $file ${HOME}/`basename $file`
    echo "$file"
done
