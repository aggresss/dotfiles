#!/usr/bin/env bash
# ubuntu bionic configuration file
# Normal installation and Install third-party software.
# wget https://raw.githubusercontent.com/aggresss/dotfiles/master/ubuntu/bionic.sh

#########################
# install necessary application
#########################
sudo apt-get update && sudo apt-get install -y \
    apt-file \
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
    python \
    default-jdk \
    pkg-config \
    flex \
    bison \
    nasm \
    yasm \
    gawk \
    net-tools \
    netcat \
    socat \
    nfs-kernel-server \
    shadowsocks \
    polipo \
    exfat-utils \
    ffmpeg \
    htop \
    nmon \
    supervisor \
    stow \
    minicom \
    \
    fonts-wqy-microhei \
    fonts-wqy-zenhei \
    xclip \
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
    awesome \
    i3 \
    xmonad \
    xmonbar \
    dwm


#########################
# install third-part applications
#########################

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
# add docker access authority to system default user
sudo usermod -a `id -nu 1000` -G docker

# visual studio code
# https://code.visualstudio.com/docs/setup/linux
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y code

# virtualbox
# https://www.virtualbox.org/wiki/Linux_Downloads
sudo add-apt-repository \
    "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian \
    $(lsb_release -cs) \
    contrib"
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install virtualbox-6.0

# vagrant
# https://www.vagrantup.com/downloads.html
VAGRANT_VERSION="2.2.3"
wget -P ${HOME}/Downloads tmp https://releases.hashicorp.com/vagrant/2.2.3/vagrant_${VAGRANT_VERSION}_x86_64.deb
sudo dpkg -i ${HOME}/Downloads/vagrant_${VAGRANT_VERSION}_x86_64.deb
if [ $? -ne 0 ]; then
    sudo apt-get -f -y install
    sudo dpkg -i ${HOME}/Downloads/vagrant_${VAGRANT_VERSION}_x86_64.deb
fi


#########################
# configuration
#########################
# gdm3
sudo sed -r -e 's/^(\[security\])/\1\nDisallowTCP=false/' -i /etc/gdm3/custom.conf

# fix: A stop job is runing ...
sudo sed -r -e 's/#DefaultTimeoutStartSec=90s/DefaultTimeoutStartSec=10s/' -i /etc/systemd/system.conf
sudo sed -r -e 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s/' -i /etc/systemd/system.conf
sudo systemctl daemon-reload

# disable apport
sudo sed -r -e 's/enabled=1/enabled=0/' -i /etc/default/apport
sudo systemctl daemon-reload

# GRUB
# save the last choice
sudo sed -r -e 's/^GRUB_DEFAULT.*$/GRUB_DEFAULT=saved\nGRUB_SAVEDEFAULT=true/' -i /etc/default/grub
# remove the splash screen on shutdown an startup
sudo sed -r -e 's/(^GRUB_CMDLINE_LINUX_DEFAULT.*$)/#\1/' -i /etc/default/grub
sudo update-grub

# dnsmasq
# config dnsmasq for polipo use
if [ -f /etc/dnsmasq.conf ]; then
    sudo sed -r -e 's/^#(port=5353)/\1/' -i /etc/dnsmasq.conf
fi

# polipo
# see /usr/share/doc/polipo/examples/config.sample
sudo chown ${USER} /etc/polipo/config
cat << END >> /etc/polipo/config

proxyAddress = "0.0.0.0"
socksParentProxy = "127.0.0.1:1080"
socksProxyType = socks5
proxyPort = 8123
allowedClients = 127.0.0.1, 172.17.0.0/16
chunkHighMark = 50331648
objectHighMark = 16384

END
sudo chown `id -nu 0` /etc/polipo/config

# shadowsocks
# modify shadowsock mode from server to client
sudo sed -r -e 's@DAEMON=/usr/bin/ssserver@DAEMON=/usr/bin/sslocal@' -i /etc/init.d/shadowsocks

