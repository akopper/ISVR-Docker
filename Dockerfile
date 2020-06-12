FROM php:7.2-apache

ARG ideaspacevr_version=1.2.2
ARG upload_max_filesize=1G
ARG php_ini_file=$PHP_INI_DIR/conf.d/php.ini
ARG php_memory_limit=1G
ARG install_dir=/var/www/html

RUN apt-get update && apt-get install -y \
        nano \
        mariadb-client \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libwebp-dev

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-webp-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql iconv

RUN cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/conf.d/php.ini
RUN a2enmod rewrite

RUN sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${upload_max_filesize}/" -e "s/^post_max_size.*/post_max_size = ${upload_max_filesize}/" $php_ini_file
RUN sed -ri -e "s/^memory_limit.*/memory_limit = ${php_memory_limit}/" $php_ini_file

RUN echo "installing IdeaspaceVR version ${ideaspacevr_version}" \
    && cd /tmp/ \
    && curl -L https://github.com/IdeaSpaceVR/IdeaSpace/releases/download/v${ideaspacevr_version}/IdeaSpace-${ideaspacevr_version}.tar.gz -o IdeaSpace-${ideaspacevr_version}.tar.gz \
    && tar xzf IdeaSpace-${ideaspacevr_version}.tar.gz \
    && echo "extracting ..." \
    && mv IdeaSpace-${ideaspacevr_version}/* $install_dir/ \
    && mv IdeaSpace-${ideaspacevr_version}/.htaccess $install_dir/

RUN echo "Patching to support reverse proxies"
COPY routes.php.patch $install_dir/
RUN cat $install_dir/routes.php.patch >> $install_dir/app/Http/routes.php

RUN chown -R www-data /var/www/
RUN chmod -R 777 /var/www/

