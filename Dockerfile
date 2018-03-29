FROM ubuntu:latest

LABEL maintainer="r.hoffmann@crolla-lowis.de"

COPY .bashrc /root/.bashrc
RUN export TERM=xterm

RUN apt-get clean && \
    apt-get update && \
    apt-get dist-upgrade -y

RUN apt-get install -y \
    software-properties-common \
    language-pack-en-base \
    imagemagick \
    rsync \
    openssh-client \
    curl \
    libicu-dev \
    build-essential \
    libssl-dev \
    ftp-upload

# add sources
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && \
    apt-get install -y \
    php7.1 \
    php7.1-cli \
    php7.1-imagick \
    php7.1-intl \
    php7.1-curl \
    php7.1-gd \
    php7.1-zip \
    php7.1-json \
    php7.1-xml \
    php7.1-mcrypt \
    php7.1-mbstring \
    composer

RUN apt-get install -y ftp yarn nodejs

USER root

# RUN echo "node: $(node -v), npm: $(npm -v), yarn: $(yarn -v)"

# preinstall annoying npm stuff
RUN npm install --unsafe --unsafe-perms -g n
RUN for ver in 4 5 6 7 8 9 latest; do n $ver; done
RUN npm install --unsafe --unsafe-perms -g grunt gulp node-sass webpack

RUN echo "node: $(node -v), npm: $(npm -v), yarn: $(yarn -v)"

# cleanup
RUN npm cache clean --force
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["bash"]