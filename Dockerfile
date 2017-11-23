FROM ubuntu:latest

LABEL maintainer="r.hoffmann@crolla-lowis.de"

COPY .bashrc /root/.bashrc
RUN export TERM=xterm

RUN apt-get update && \
    apt-get dist-upgrade -y

RUN apt-get install -y \
    software-properties-common \
    imagemagick \
    rsync \
    openssh-client \
    curl \
    libicu-dev

RUN apt-get install -y \
    php \
    php-cli \
    php-imagick \
    php-intl \
    php-curl \
    php-gd \
    php-zip \
    php-json \
    php-mcrypt \
    php-mbstring \
    composer

RUN apt-get install -y build-essential

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

RUN node -v && npm -v


# RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
# RUN export NVM_DIR="$HOME/.nvm" && . $NVM_DIR/nvm.sh
# RUN nvm use latest

USER root

# preinstall annoying stuff
RUN npm install --unsafe --unsafe-perms -g yarn gulp grunt node-sass
RUN npm cache clean --force
# node-sass 

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["bash"]