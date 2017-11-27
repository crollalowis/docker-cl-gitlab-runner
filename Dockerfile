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
    libicu-dev \
    build-essential \
    libssl-dev 

# add sources
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get install -y \
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

RUN apt-get install -y ftp yarn nodejs

USER root

# install n node version manager
# RUN curl -L https://git.io/n-install | bash
# RUN . ~/.bashrc

RUN echo "node: $(node -v), npm: $(npm -v), yarn: $(yarn -v)"

# preinstall annoying npm stuff
RUN npm install --unsafe --unsafe-perms -g n
RUN n latest

RUN echo "node: $(node -v), npm: $(npm -v), yarn: $(yarn -v)"

# RUN npm cache clean --force

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["bash"]