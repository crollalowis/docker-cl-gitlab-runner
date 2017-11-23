FROM ubuntu:latest

MAINTAINER Richard Hoffmann "r.hoffmann@crolla-lowis.de"

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
    software-properties-common \
    nodejs \
    php \
    rsync \
    openssh-client \
    php-cli \
    libicu-dev \
    php-apcu \
    php-intl \
    php-gd \
    php-json \
    php-mbstring \
    php-xml \
    php-xsl \
    php-zip \
    composer

RUN npm install -g nvm yarn grunt gulp

# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/
# RUN mv /usr/bin/composer.phar /usr/bin/composer

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# TODO: maybe change user or owner to be able to install global stuff