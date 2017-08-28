FROM php:5.6-fpm

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget unzip zlib1g-dev libmagickwand-dev libfreetype6-dev libjpeg62-turbo-dev libpng12-dev uuid-dev libmcrypt-dev libxslt1-dev libicu-dev && rm -rf /var/lib/apt/lists/* && \

    # Install libmemcached
    wget https://launchpad.net/libmemcached/1.0/1.0.14/+download/libmemcached-1.0.14.tar.gz && tar xvzf libmemcached-1.0.14.tar.gz && cd libmemcached-1.0.14 && ./configure --disable-sasl && make && make install && cd .. && rm -rf libmemcached-* && \

    # Install pecl memcached
    echo "no --disable-memcached-sasl" | pecl install memcached-2.1.0 && \

    # Install other pecl
    yes | pecl install imagick uuid apcu-4.0.10 raphf-1.1.2 propro-1.0.2 && \

     # Install patched xdebug
    wget https://github.com/SteveEasley/xdebug/archive/rfc7239.zip -O /tmp/xdebug.zip && cd /tmp && unzip xdebug.zip && cd xdebug-rfc7239 && phpize && ./configure --enable-xdebug && make && cp modules/xdebug.so $(php -r 'echo ini_get("extension_dir");') && cd / && rm -rf /tmp/xdebug* && \

	# Enable above pecl extensions
    docker-php-ext-enable memcached imagick uuid apcu raphf propro && \

    # Install pecl http (raphf needs to be installed already)
    yes | pecl install pecl_http-2.5.5 && docker-php-ext-enable http && \

    # Install gd extension
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ && \

    # Install other extensions
    docker-php-ext-install -j$(nproc) opcache mysql mysqli pdo_mysql intl mbstring bz2 gd exif sockets sysvsem sysvshm sysvmsg wddx shmop calendar dom xsl soap xmlrpc pcntl
