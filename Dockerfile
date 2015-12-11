FROM debian:wheezy

MAINTAINER Geraldus <heraldhoi@gmail.com>

# Preparations for fish 2.0 installation
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key D880C8E4 \
 && echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_7.0/ ./' \
         > /etc/apt/sources.list.d/fish-shell.list

# fish shell requires TERM to be set
ENV TERM xterm

# Basic tools and GHC deps
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
            locales \
            fish \
            git
            bzip2 \
            ca-certificates \
            libc6-dev \
            libgmp-dev \
            libgmp10 \
            make \
            patch \
            wget \
            zlib1g-dev \
            autoconf \
            automake \
            libtool \
            ncurses-dev \
            g++ \
            python \
 && rm -rf /var/lib/apt/lists/*

# Locale setup
RUN mkdir -p ~/.config/fish \
 && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen \
 && update-locale LANG=en_US.UTF-8 \
 && echo ": ${LANG=en_US.utf8}; export LANG" >> /etc/profile \
 && echo "set -xg LANG en_US.utf8" >> ~/.config/fish/config.fish

RUN mkdir /root/tmp \
 && rm -fr /tmp/*

# Stack support

RUN useradd -m -U -s /bin/bash stack -p "stack" \
 && passwd -d stack \
 && su stack -c "mkdir /home/stack/.stack"

CMD ["fish"]
