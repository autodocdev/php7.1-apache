FROM autodoc/ubuntu-base:latest

MAINTAINER Danilo Correa <dcorrea@autodoc.com.br>

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
    php7.1-dev \
    php-memcached \
    libapache2-mod-php7.1 \
    nodejs \
    apache2 && \
    npm install -g bower && \
    pecl install grpc

ENV APACHE_RUN_USER application
ENV APACHE_RUN_GROUP application
ENV APACHE_SERVER_NAME localhost
ENV APACHE_HTTP_PORT 8888

ENV GIT_NAME teste
ENV GIT_EMAIL teste@teste.com.br

USER application
RUN git config --global user.name $GIT_NAME
RUN git config --global user.email $GIT_EMAIL


USER root
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

RUN \
    curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar && \
    chmod +x phpcs.phar && \
    mv phpcs.phar /usr/local/bin/phpcs

RUN \
    curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar && \
    chmod +x phpcbf.phar && \
    mv phpcbf.phar /usr/local/bin/phpcbf

RUN \
    curl -OL http://static.phpmd.org/php/latest/phpmd.phar && \
    chmod +x phpmd.phar && \
    mv phpmd.phar /usr/local/bin/phpmd


RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

EXPOSE 8888

WORKDIR /home/application

CMD /usr/sbin/apache2ctl -D FOREGROUND
