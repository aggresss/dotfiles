#!/usr/bin/env bash
# ubuntu bionic configuration file
# Normal installation and Install third-party software.
# wget https://raw.githubusercontent.com/aggresss/dotfiles/main/ubuntu/bionic.sh

#########################
# install necessary application
#########################
sudo apt-get update && sudo apt-get install -y \
    zlib1g-dev \
    apt-file \
    trash-cli \
    alsa-utils \
    mc \
    tree \
    curl \
    httpie \
    jq \
    zsh \
    emacs \
    vim \
    ctags \
    cscope \
    ssh \
    mosh \
    git \
    git-lfs \
    p7zip-full \
    unrar \
    libarchive-tools \
    hexedit \
    tmux \
    expect \
    build-essential \
    libncurses5 \
    gcc-multilib \
    openjdk \
    maven \
    clang \
    clang-tools \
    clang-format \
    clang-tidy \
    automake \
    ninja-build \
    libtool \
    libtool-bin \
    cmake \
    cmake-curses-gui \
    ccache \
    python-is-python3 \
    python-dev \
    python3-dev \
    python-pip \
    virtualenv \
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
    nmap \
    netcat \
    socat \
    nfs-kernel-server \
    shadowsocks \
    polipo \
    exfat-utils \
    ffmpeg \
    gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad \
    cpu-checker \
    htop \
    iftop \
    nmon \
    bmon \
    sysstat \
    supervisor \
    stow \
    minicom \
    lcov \
    systemtap \
    valgrind \
    protobuf-compiler \
    oprofile \
    lttng-tools \
    linux-tools-generic \
    linux-tools-common \
    imagemagick \
    doxygen \
    mtp-tools \
    jmtpfs \
    gettext \
    autopoint \
    nodejs \
    lua5.1 \
    ruby \
    libssl-dev \
    libproxy-dev \
    libxml2-dev \
    vpnc-scripts

sudo apt-get update && sudo apt-get install -y \
    default-jdk \
    gnome \
    fonts-dejavu \
    fonts-wqy-microhei \
    fonts-wqy-zenhei \
    x11-apps \
    xinput \
    xclip \
    xbacklight \
    xkbset \
    xdotool \
    vlc \
    pavucontrol \
    chromium-browser \
    slock \
    okular \
    xvnc4viewer \
    remmina \
    scrot \
    imagemagick \
    meld \
    xterm \
    fcitx-libpinyin \
    fcitx-sunpinyin \
    fcitx-ui-light \
    gnome-tweak-tool \
    gnome-screensaver \
    libnotify-bin \
    awesome \
    i3 \
    i3status \
    i3lock \
    xmonad \
    xmobar \
    dwm \
    gimp \
    valkyrie \
    gpicview \
    cmake-gui \
    graphviz \
    kcachegrind \
    doxygen-gui \
    virt-manager \
    qemu \
    wireshark
