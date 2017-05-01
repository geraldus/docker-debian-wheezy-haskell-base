FROM debian:wheezy

MAINTAINER Geraldus <heraldhoi@gmail.com>

ENV TERM xterm

# Basic tools and GHC deps
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
            locales \
            git \
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

# POSTGRESQL 9.4
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
 && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
            postgresql-9.4 \
            libpq-dev \
 && rm -rf /var/lib/apt/lists/*

# FISH SHELL 2.4.0
RUN echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2:/2.4.0/Debian_7.0/ /' > /etc/apt/sources.list.d/fish.list \
 && wget -nv http://download.opensuse.org/repositories/shells:fish:release:2:2.4.0/Debian_7.0/Release.key -O Release.key \
 && apt-key add - < Release.key \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
            libjs-jquery \
            bc \
            gettext-base \
            man-db \
            fish \
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
