#!/usr/bin/env bash
# ubuntu bionic configuration file
# Normal installation and Install third-party software.
# wget https://raw.githubusercontent.com/aggresss/dotfiles/master/ubuntu/bionic.sh

#########################
# install necessary application
#########################
sudo apt-get update && sudo apt-get install -y \
    apt-file \
    alsa-utils \
    mc \
    tree \
    curl \
    jq \
    emacs \
    vim \
    ctags \
    cscope \
    ssh \
    mosh \
    git \
    p7zip-full \
    unrar \
    hexedit \
    tmux \
    build-essential \
    gcc-multilib \
    automake \
    libtool \
    cmake \
    ccache \
    python-dev \
    python3-dev \
    virtualenv \
    default-jdk \
    pkg-config \
    flex \
    bison \
    nasm \
    yasm \
    gawk \
    net-tools \
    wireless-tools \
    samba \
    smbclient \
    cifs-utils \
    netcat \
    socat \
    nfs-kernel-server \
    shadowsocks \
    polipo \
    exfat-utils \
    ffmpeg \
    htop \
    nmon \
    bmon \
    supervisor \
    stow \
    minicom \
    lcov \
    systemtap \
    valgrind \
    oprofile \
    lttng-tools \
    linux-tools-generic \
    linux-tools-common \
    imagemagick \
    doxygen \
    \
    gnome \
    fonts-wqy-microhei \
    fonts-wqy-zenhei \
    xclip \
    xbacklight \
    vlc \
    chromium-browser \
    slock \
    okular \
    xvnc4viewer \
    remmina \
    flashplugin-installer \
    scrot \
    imagemagick \
    meld \
    xterm \
    fcitx-sunpinyin \
    gnome-tweak-tool \
    gnome-screensaver \
    libnotify-bin \
    awesome \
    i3 \
    i3status \
    xmonad \
    dwm \
    gimp \
    valkyrie \
    gpicview \
    cmake-gui \
    graphviz \
    kcachegrind \
    doxygen-gui

