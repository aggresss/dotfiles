#!/usr/bin/env bash
# update i3 config
set -e

echo "Update i3 config ..."
mkdir -p ${HOME}/.config/i3
cp -f config_i3 ${HOME}/.config/i3/config

echo "Update i3status config ..."
mkdir -p ${HOME}/.config/i3status
cp -f config_i3status ${HOME}/.config/i3status/config

echo "Update i3 config successful."
