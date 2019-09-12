FROM debian:stretch

LABEL maintainer="r.hoffmann@crolla-lowis.de"

COPY .bashrc /root/.bashrc
RUN export TERM=xterm

RUN apt-get update

RUN apt-get install -y \
  software-properties-common \
  imagemagick \
  rsync \
  openssh-client \
  curl \
  libicu-dev \
  build-essential \
  libssl-dev \
  ftp-upload \
  apt-transport-https \
  lsb-release ca-certificates


# add sources
RUN curl https://packages.sury.org/php/apt.gpg | apt-key add -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

RUN apt-get update && \
  apt-get install -y \
  php5.6 \
  php5.6-cli \
  php5.6-imagick \
  php5.6-intl \
  php5.6-curl \
  php5.6-gd \
  php5.6-zip \
  php5.6-json \
  php5.6-xml \
  php5.6-mcrypt \
  php5.6-mbstring \
  composer

RUN apt-get install -y ftp yarn nodejs

USER root

# RUN echo "node: $(node -v), npm: $(npm -v), yarn: $(yarn -v)"

# preinstall annoying npm stuff
RUN npm install --unsafe --unsafe-perms -g n
RUN for ver in 4 5 6 7 8 9 10 11 latest; do n $ver; done
RUN npm install --unsafe --unsafe-perms -g grunt gulp node-sass webpack

RUN echo "php: $(php -v), node: $(node -v), npm: $(npm -v), yarn: $(yarn -v)"

# cleanup
RUN npm cache clean --force
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["bash"]