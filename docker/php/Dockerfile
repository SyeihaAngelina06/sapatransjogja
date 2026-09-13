FROM php:8.3-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    postgresql-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    oniguruma-dev \
    bash

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_pgsql \
        pgsql \
        gd \
        zip \
        bcmath \
        pcntl \
        opcache \
        exif

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/laravel

# Copy source code
COPY sapa-laravel/ /var/www/laravel/

# Copy custom php.ini
COPY docker/php/php.ini /usr/local/etc/php/conf.d/custom.ini

# Copy entrypoint script
COPY docker/php/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Run composer install with optimized autoloader
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Set directory permissions
RUN chown -R www-data:www-data /var/www/laravel \
    && chmod -R 775 /var/www/laravel/storage /var/www/laravel/bootstrap/cache

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]
