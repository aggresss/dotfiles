#!/bin/bash
# ubuntu bionic configuration file
# wget https://raw.githubusercontent.com/aggresss/dotfiles/master/ubuntu/bionic.sh
sed -i 's/archive.ubuntu/mirrors.aliyun/g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y --no-install-recommends \
        sudo \
        man \
        tzdata \
        locales \
        tree \
        curl \
        wget \
        rsync \
        vim \
        ssh \
        git \
        ca-certificates \
        unzip \
        xz-utils \
        p7zip-full \
        hexedit \
        tmux \
        build-essential \
        gdb \
        gdbserver \
        autoconf \
        automake \
        libtool \
        cmake \
        ccache \
        python \
        pkg-config \
        flex \
        bison \
        yasm \
        gawk \
        net-tools \
        iputils-ping \
        netcat 
