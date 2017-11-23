FROM ubuntu:latest

MAINTAINER Richard Hoffmann "r.hoffmann@crolla-lowis.de"

COPY .bashrc /root/.bashrc
RUN export TERM=xterm

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
    software-properties-common \
    curl \
    php \
    rsync \
    openssh-client \
    php-cli \
    libicu-dev \
    php-intl \
    php-gd \
    php-json \
    php-mbstring \
    composer

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# RUN source /root/.bashrc

RUN node -v
# RUN npm install -g nvm yarn grunt gulp

# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/
# RUN mv /usr/bin/composer.phar /usr/bin/composer

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# TODO: maybe change user or owner to be able to install global stuff

CMD ["bash"]