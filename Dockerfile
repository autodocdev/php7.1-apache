FROM autodoc/ubuntu-base:latest

MAINTAINER Danilo Correa <danilosilva87@gmail.com>

USER root

RUN add-apt-repository -y -u ppa:ondrej/php && \
    apt-get update -y --no-install-recommends && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y \
    php7.1 \
    php7.1-cli \
    php7.1-common \
    php7.1-curl \
    php7.1-gd \
    php7.1-gmp \
    php7.1-imap \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-pgsql \
    php7.1-opcache \
    php7.1-mysql \
    php7.1-soap \
    php7.1-xmlrpc \
    php7.1-xml \
    php7.1-sqlite3 \
    php7.1-xsl \ 
    php7.1-zip \
    php-memcached \
    libapache2-mod-php7.1 \
    nodejs \
    apache2 && \
    npm install -g bower

ENV APACHE_RUN_USER application
ENV APACHE_RUN_GROUP application

ADD ./php.ini /etc/php/7.1/apache2
ADD ./php.ini /etc/php/7.1/cli
ADD ./envvars /etc/apache2/

COPY sites-enabled/*.conf /etc/apache2/sites-enabled/
    
RUN a2enmod rewrite ssl

RUN \
    curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer

RUN \
    curl -LO https://deployer.org/deployer.phar && \
    mv deployer.phar /usr/local/bin/dep && \
    chmod +x /usr/local/bin/dep

RUN \
    curl -LO https://phar.phpunit.de/phpunit.phar && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit


EXPOSE 8888

WORKDIR /home/application

CMD /usr/sbin/apache2ctl -D FOREGROUND
