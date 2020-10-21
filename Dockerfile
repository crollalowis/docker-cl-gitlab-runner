FROM debian:buster

USER root

LABEL maintainer="r.hoffmann@crolla-lowis.de"

COPY .bashrc /root/.bashrc

ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Europe/Berlin" > /etc/timezone

# install our runner requirements

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
  ca-certificates \
  apt-transport-https \
  lsb-release \
  software-properties-common \
  # language-pack-en-base \
  zsh \
  bash \
  imagemagick \
  rsync \
  openssh-client \
  curl \
  wget \
  gnupg-agent \
  libmcrypt-dev \
  libreadline-dev \
  libicu-dev \
  build-essential \
  libssl-dev \
  zip \
  ftp \
  ftp-upload

# Install docker

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88

RUN echo $(lsb_release -cs)

RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

RUN apt-get update
RUN apt-get install docker-ce docker-ce-cli containerd.io -y

RUN curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

RUN chmod +x /usr/local/bin/docker-compose
RUN ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# instll latest nodejs

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && \
  apt-get install -y \
  nodejs

# install php shit
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.4.list

RUN apt-cache search php7.4

RUN apt-get update && \
  apt-get install -y \
  php7.4 \
  php7.4-cli \
  php7.4-imagick \
  php7.4-intl \
  php7.4-apcu \
  php7.4-mysql \
  php7.4-pdo-mysql \
  php7.4-curl \
  php7.4-gd \
  php7.4-zip \
  php7.4-json \
  php7.4-xml \
  php7.4-intl \
  # php7.4-mcrypt \
  php7.4-mbstring \
  composer

# avoid million NPM install messages
ENV npm_config_loglevel warn
# allow installing when the main user is root
ENV npm_config_unsafe_perm true

RUN npm install --unsafe --unsafe-perms -g node-sass npm yarn

RUN rm -rf /var/lib/apt/lists/*

WORKDIR '/root'
RUN usermod -aG docker root
COPY ./start.sh start.sh

# versions of local tools
RUN echo \
  "node version:    $(node -v) \n" \
  "php version:     $(php -v) \n" \
  "npm version:     $(npm -v) \n" \
  "git version:     $(git --version) \n" \
  "yarn version:    $(yarn -v) \n" \
  "debian version:  $(cat /etc/debian_version) \n" \
  "user:            $(whoami) \n"\
  "docker:          $(docker -v)\n"\
  "docker-compose:  $(docker-compose -v)\n"\
  "DOCKER_HOST:     $(env | grep DOCKER_HOST)\n"

CMD ["sh", "start.sh"]