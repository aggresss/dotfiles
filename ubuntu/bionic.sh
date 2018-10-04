#!/bin/bash
# ubuntu bionic configuration file
# Normal installation and Install third-party software.
# wget https://raw.githubusercontent.com/aggresss/dotfiles/master/ubuntu/bionic.sh

sudo apt-get update && sudo apt-get install -y \
    tree \
    curl \
    vim \
    ssh \
    git \
    p7zip-full \
    hexedit \
    tmux \
    build-essential \
    automake \
    libtool \
    cmake \
    ccache \
    python \
    pkg-config \
    flex \
    bison \
    nasm \
    yasm \
    gawk \
    net-tools \
    netcat \
    nfs-kernel-server \
    \
    fonts-wqy-microhei \
    fonts-wqy-zenhei \
    xclip \
    vlc \
    chromium-browser \
    slock \
    minicom \
    okular \
    xvnc4viewer \
    flashplugin-installer \
    scrot \
    imagemagick \
    meld \
    xterm \
    awesome \
    i3 \
    xmonad \
    dwm

#
# install third-part applications
#

# docker
# https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository
sudo apt-get remove -y docker docker-engine docker.io && \
    sudo apt-get update && \
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    sudo apt-get update && sudo apt-get install -y docker-ce

# visual studio code
# https://code.visualstudio.com/docs/setup/linux
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y code

