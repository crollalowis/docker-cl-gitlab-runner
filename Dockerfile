FROM debian:stable

USER root

ARG FIREFOX_VERSION=68.0.2

LABEL maintainer="r.hoffmann@crolla-lowis.de"

COPY .bashrc /root/.bashrc
ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Europe/Berlin" > /etc/timezone

# install our runner requirements

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
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

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && \
    apt-get install -y \
    nodejs

# install php shit

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
    # php7.3-mcrypt \
    php7.3-mbstring \
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