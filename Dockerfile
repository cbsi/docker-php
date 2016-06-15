FROM php:5.6-fpm

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget zlib1g-dev libmagickwand-dev libfreetype6-dev libjpeg62-turbo-dev libpng12-dev uuid-dev libmcrypt-dev libxslt1-dev libicu-dev && \
    wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz && tar xvzf libmemcached-1.0.18.tar.gz && cd libmemcached-1.0.18 && ./configure --disable-sasl && make && make install && cd .. && rm -rf libmemcached-* && \
    echo "no --disable-memcached-sasl" | pecl install memcached-2.1.0 && \
    yes | pecl install imagick uuid apcu-4.0.10 raphf-1.1.2 propro-1.0.2 && \
    docker-php-ext-enable memcached imagick uuid apcu raphf propro && \
    yes | pecl install pecl_http-2.5.5 && docker-php-ext-enable http && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) opcache mysql pdo_mysql intl mbstring bz2 gd exif sockets sysvsem sysvshm sysvmsg wddx shmop calendar dom xsl soap xmlrpc && \
    rm -rf /var/lib/apt/lists/*
