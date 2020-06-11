FROM php:7.2-apache

ARG ideaspacevr_version=1.2.2
ARG upload_max_filesize=1G
ARG php_ini_file=$PHP_INI_DIR/conf.d/php.ini
ARG install_dir=/var/www/html

RUN apt-get update \
    && apt-get install -y libmagickwand-dev mariadb-client nano \
    && pecl install imagick-3.4.4 \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-enable imagick mysqli pdo pdo_mysql \
    && apt-get clean

RUN cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/conf.d/php.ini
RUN a2enmod rewrite

RUN sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${upload_max_filesize}/" -e "s/^post_max_size.*/post_max_size = ${upload_max_filesize}/" $php_ini_file

RUN echo "installing IdeaspaceVR version ${ideaspacevr_version}" \
    && cd /tmp/ \
    && curl -L https://github.com/IdeaSpaceVR/IdeaSpace/releases/download/v${ideaspacevr_version}/IdeaSpace-${ideaspacevr_version}.tar.gz -o IdeaSpace-${ideaspacevr_version}.tar.gz \
    && tar xzf IdeaSpace-${ideaspacevr_version}.tar.gz \
    && echo "extracting ..." \
    && mv IdeaSpace-${ideaspacevr_version}/* $install_dir/ \
    && mv IdeaSpace-${ideaspacevr_version}/.htaccess $install_dir/

RUN chown -R www-data /var/www/
RUN chmod -R 777 /var/www/

