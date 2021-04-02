FROM php:7.4-apache as scratch

ARG APP_ENV
ENV APP_ENV=${APP_ENV}

RUN apt-get update && apt-get install -y git git-core zip wget unzip vim gnupg curl \
    libonig-dev \
    libzip-dev \
    zlib1g-dev \
    libpq-dev \
    libmcrypt-dev \
    libfcgi0ldbl \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli bcmath intl pcntl mbstring bcmath gd zip \
    && pecl install mcrypt \
    && docker-php-ext-enable mcrypt \
    && chmod 777 -R /tmp && chmod o+t -R /tmp \
    && a2enmod rewrite \
    #MAKE tmp WRITABLE
    && chmod 777 -R /tmp && chmod o+t -R /tmp \
    && wget https://getcomposer.org/installer -O - -q | php -- --install-dir=/bin --filename=composer --quiet

ENV COMPOSER_ALLOW_SUPERUSER 1

WORKDIR /var/www/html

# DEV env (local)
FROM scratch as dev

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# PROD env (kubernetes)
FROM scratch as prod

RUN /usr/bin/composer install --no-ansi --no-dev -n --no-plugins --no-progress --no-scripts --no-suggest -o \
    && chown -R www-data:www-data .

USER www-data:www-data
CMD ["apache2-foreground"]