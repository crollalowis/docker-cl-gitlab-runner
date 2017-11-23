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

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

RUN node -v

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["bash"]