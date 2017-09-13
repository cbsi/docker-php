FROM php:7.0-fpm

RUN apt-get -qq update && \
    apt-get install -y --no-install-recommends wget && \
    apt-get update && \
    apt-get install -y --no-install-recommends unzip zlib1g-dev libmagickwand-dev  libmemcached11 libmemcached-dev  libfreetype6-dev libjpeg62-turbo-dev libpng12-dev libmcrypt-dev libxslt1-dev libicu-dev && rm -rf /var/lib/apt/lists/* && \

    # Install pecl memcached
    echo "no --disable-memcached-sasl" | pecl install memcached-3.0.3 && \

    # Install other pecl
    yes | pecl install imagick apcu-5.1.8 && \
    
    yes | pecl install imagick xdebug-2.5.1 && \
    yes | pecl install imagick igbinary-2.0.1 && \

	# Enable above pecl extensions
    docker-php-ext-enable memcached imagick apcu igbinary && \

    # Install gd extension
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ && \

    # Install other extensions
    docker-php-ext-install -j$(nproc) opcache mysql mysqli pdo pdo_mysql intl mbstring bz2 gd exif sockets sysvsem sysvshm sysvmsg wddx shmop calendar dom xsl soap xmlrpc pcntl
