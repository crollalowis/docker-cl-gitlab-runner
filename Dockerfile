FROM ubuntu:latest

LABEL maintainer="r.hoffmann@crolla-lowis.de"

COPY .bashrc /root/.bashrc
ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Europe/Berlin" > /etc/timezone

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
    libmcrypt-dev \
    libreadline-dev \
    libicu-dev \
    build-essential \
    libssl-dev \
    ftp-upload

# add sources
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && \
    apt-get install -y \
    php7.3 \
    php7.3-cli \
    php7.3-imagick \
    php7.3-intl \
    php7.3-apcu \
    php7.3-mysql \
    php7.3-pdo-mysql \
    php7.3-curl \
    php7.3-gd \
    php7.3-zip \
    php7.3-json \
    php7.3-xml \
    php7.3-intl \
    # php7.3-pecl \
    # php7.3-mcrypt \
    php7.3-mbstring \
    composer

# RUN bash -c "echo extension=/usr/lib/php/20170718/mcrypt.so > /etc/php/7.2/cli/conf.d/mcrypt.ini"
# RUN bash -c "echo extension=/usr/lib/php/20170718/mcrypt.so > /etc/php/7.2/apache2/conf.d/mcrypt.ini"
# RUN bash -c "echo extension=mcrypt.so > /etc/php/7.2/php.ini"

RUN apt-get install -y ftp yarn nodejs

USER root

# preinstall heavy npm stuff
RUN npm install --unsafe --unsafe-perms -g node-sass phantomjs-prebuilt
RUN echo "node: $(node -v), npm: $(npm -v), yarn: $(yarn -v), php: $(php -v)"

# cleanup
# RUN npm cache clean --force
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["bash"]