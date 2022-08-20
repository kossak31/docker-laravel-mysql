#! /bin/sh

php artisan config:cache 
php artisan config:clear 
php artisan cache:clear 
php artisan key:generate
php artisan migrate || exit 122
# php artisan vendor:publish --all || exit 123
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf