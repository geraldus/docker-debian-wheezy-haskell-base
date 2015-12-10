FROM debian:wheezy

MAINTAINER Geraldus <heraldhoi@gmail.com>

# Preparations for fish 2.0 installation
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key D880C8E4
RUN echo \
 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_7.0/ ./' \
 > /etc/apt/sources.list.d/fish-shell.list

# fish shell requires TERM to be set
ENV TERM xterm

RUN apt-get update


# Basic tools
RUN apt-get install -y --no-install-recommends \
            locales \
            fish \
            git


# Locale setup
RUN mkdir -p ~/.config/fish

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen \
 && update-locale LANG=en_US.UTF-8 \
 && echo ": ${LANG=en_US.utf8}; export LANG" >> /etc/profile \
 && echo "set -xg LANG en_US.utf8" >> ~/.config/fish/config.fish

# GHC Dependencies
RUN apt-get install -y --no-install-recommends \
            bzip2 \
            ca-certificates \
            gcc \
            libc6-dev \
            libgmp-dev \
            libgmp10 \
            make \
            patch \
            wget \
            zlib1g-dev

RUN mkdir /root/tmp

# # GHC itself
# WORKDIR /root/tmp/sources
# RUN wget http://downloads.haskell.org/~ghc/7.8.4/ghc-7.8.4-x86_64-unknown-linux-deb7.tar.bz2 \
#   && echo '20b5731d268613bbf6e977dbb192a3a3b7b78d954c35edbfca4fb36b652e24f7  ghc-7.8.4-x86_64-unknown-linux-deb7.tar.bz2' | sha256sum -c - \
#   && tar --strip-components=1 -xjvf ghc-7.8.4-x86_64-unknown-linux-deb7.tar.bz2 \
#   && rm ghc-7.8.4-x86_64-unknown-linux-deb7.tar.bz2 \
#   && ./configure \
#   && make install \
#   && rm -fr /usr/src/ghc
# WORKDIR /

# RUN ghc --version

# # cabal-install
# WORKDIR /root/tmp

# RUN git clone https://github.com/haskell/cabal.git

# WORKDIR cabal
# RUN git checkout tags/cabal-install-v1.22.0.0
# WORKDIR cabal-install
# RUN ./bootstrap.sh

# ENV PATH /root/.cabal/bin:$PATH

# # Updating Cabal library
# RUN cabal update
# RUN cabal install Cabal-1.22.0.0 \
#  && ghc-pkg hide Cabal-1.18.1.5

# RUN cabal --version
# RUN ghc-pkg list Cabal

# Cleanup
WORKDIR /
RUN rm -fr /root/tmp/*

# RUN for pkg in `ghc-pkg --user list  --simple-output`; \
#       do ghc-pkg unregister --force $pkg; \
#     done

RUN rm -rf /var/lib/apt/lists/*

CMD ["ghci"]
