FROM marmotz/debian-fr:wheezy

USER root

ADD init_php.sh /

# PHP
RUN echo 'deb http://packages.dotdeb.org wheezy-php56 all' | tee /etc/apt/sources.list.d/dotdeb.list && \
    wget -O- -q https://www.dotdeb.org/dotdeb.gpg | apt-key add - && \
    apt-get update -y && \
    apt-get install -y --force-yes php5-cli php5-mysql php5-json php5-xsl php5-intl php5-xdebug php5-curl php5-gd php5-apcu php-pear

# Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer

# Xdebug
ADD xdebug.ini /etc/php5/mods-available/xdebug.ini
RUN php5enmod xdebug

# TIMEZONE in php
RUN sed -i "s@^;date.timezone =.*@date.timezone = $TIMEZONE@" /etc/php5/*/php.ini

# DEV conf for php
RUN sed -i "s@^error_reporting =.*@error_reporting = E_ALL@" /etc/php5/*/php.ini
RUN sed -i "s@^display_errors =.*@display_errors = On@" /etc/php5/*/php.ini
RUN sed -i "s@^display_startup_errors =.*@display_startup_errors = On@" /etc/php5/*/php.ini

USER nonrootuser

VOLUME [ "/var/php" ]
WORKDIR /var/php
CMD ["/init_php.sh"]
