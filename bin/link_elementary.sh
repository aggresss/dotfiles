#!/usr/bin/env bash
# Bash file for link elementary
# Author: @aggresss

for file in /mnt/*; do
    ln -s $file ${HOME}/`basename $file`
done
