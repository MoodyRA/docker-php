FROM php:8.3-fpm-alpine

# Install dependencies
RUN apk --no-cache add bash git curl nginx wget dpkg

# Add PHP extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions iconv zip intl opcache zip soap gd imagick apcu redis pdo pdo_pgsql xdebug

# Symfony tool
RUN apk add --no-cache bash && \
    curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh' | bash && \
    apk add symfony-cli

# composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# config
ADD *.ini /usr/local/etc/php/conf.d/

WORKDIR /var/www

# xdebug
EXPOSE 9003
