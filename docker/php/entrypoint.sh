#!/bin/bash
set -e

# Buat .env dari .env.example jika belum ada
if [ ! -f /var/www/laravel/.env ]; then
    if [ -f /var/www/laravel/.env.example ]; then
        echo "Creating .env from .env.example..."
        cp /var/www/laravel/.env.example /var/www/laravel/.env
    fi
fi

# Pastikan permission folder storage dan bootstrap/cache
mkdir -p /var/www/laravel/storage/framework/{sessions,views,cache}
mkdir -p /var/www/laravel/storage/logs
chown -R www-data:www-data /var/www/laravel/storage /var/www/laravel/bootstrap/cache
chmod -R 775 /var/www/laravel/storage /var/www/laravel/bootstrap/cache

# Generate APP_KEY jika belum terisi
if ! grep -q "^APP_KEY=base64:" /var/www/laravel/.env 2>/dev/null; then
    echo "Generating Laravel APP_KEY..."
    php artisan key:generate --force --no-interaction || true
fi

# Storage symlink
php artisan storage:link --no-interaction || true

# Bersihkan cache agar environment dinamis terbaca
php artisan config:clear || true
php artisan route:clear || true
php artisan view:clear || true

echo "Laravel Backend Ready!"

exec "$@"
