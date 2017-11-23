FROM ubuntu:latest

MAINTAINER Richard Hoffmann "r.hoffmann@crolla-lowis.de"

RUN apt-get -y install software-properties-common
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
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

# RUN sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/
# RUN mv /usr/bin/composer.phar /usr/bin/composer

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ADD run.sh /run.sh
# RUN chmod 755 /*.sh

# Add our fpm configuration
# COPY fpm.conf /etc/php5/fpm/pool.d/www.conf
# Add our apache configuration

# COPY apache2.conf /etc/apache2/apache2.conf

# Enable required modules
# RUN ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/fpm/conf.d/20-mcrypt.ini
# RUN ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/cli/conf.d/20-mcrypt.ini

# Enable Xdebug remote_connect_back
# RUN echo "xdebug.remote_connect_back=on" >> /etc/php5/mods-available/xdebug.ini
# RUN echo "xdebug.remote_enable=on" >> /etc/php5/mods-available/xdebug.ini
# RUN echo "xdebug.remote_autostart=on" >> /etc/php5/mods-available/xdebug.ini
# RUN echo "xdebug.remote_port=9001" >> /etc/php5/mods-available/xdebug.ini

# Give www-data write access to mounted volumes
# RUN usermod -u 1000 www-data

# Enable apache modules
# RUN a2enmod proxy_fcgi
# RUN a2enmod rewrite
# RUN a2enmod headers

# EXPOSE 80

# CMD ["/run.sh"]