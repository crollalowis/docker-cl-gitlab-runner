FROM debian:stretch

USER root

ARG FIREFOX_VERSION=79.0

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
  imagemagick \
  rsync \
  openssh-client \
  curl \
  wget \
  libmcrypt-dev \
  libreadline-dev \
  libicu-dev \
  build-essential \
  libssl-dev \
  zip \
  ftp \
  ftp-upload

RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
RUN apt-get update
RUN apt-get install -y google-chrome-stable

# "fake" dbus address to prevent errors
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

RUN wget --no-verbose -O /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
  && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
  && rm /tmp/firefox.tar.bz2 \
  && ln -fs /opt/firefox/firefox /usr/bin/firefox

# install cypress deps

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  libgtk2.0-0 \
  libgtk-3-0 \
  libnotify-dev \
  libgconf-2-4 \
  libnss3 \
  libxss1 \
  libasound2 \
  libxtst6 \
  xauth \
  xvfb


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


# versions of local tools
RUN echo  " node version:    $(node -v) \n" \
  "php version:     $(php -v) \n" \
  "npm version:     $(npm -v) \n" \
  "git version:     $(git --version) \n" \
  "yarn version:    $(yarn -v) \n" \
  "chrome version:  $(google-chrome --version) \n" \
  "firefox version: $(firefox --version) \n" \
  "debian version:  $(cat /etc/debian_version) \n" \
  "user:            $(whoami) \n"

CMD ["bash"]