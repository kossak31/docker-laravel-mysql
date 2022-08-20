FROM composer AS composer

COPY ./src /app
WORKDIR /app

RUN composer install \
  --optimize-autoloader \
  --no-interaction \
  --no-progress

RUN composer dump-autoload

COPY ./src/.env.local /app/.env

FROM trafex/php-nginx

COPY --chown=nginx --from=composer /app /var/www/html
COPY --chown=nobody ./common/entrypoint.sh /var/www/entrypoint.sh
COPY --chown=nginx ./common/nginx.conf /etc/nginx/nginx.conf


USER root
RUN apk update && apk add bash
RUN apk add --no-cache php81-tokenizer php81-pdo_mysql php81-mbstring php81-exif php81-pcntl php81-bcmath php81-gd php81-zip php81-fileinfo php81-xmlwriter  php81-simplexml

RUN chmod -R 777 /var/www/html/storage
RUN chmod -R 777 /var/www/html/bootstrap/cache
RUN chmod 777 /var/www/html/.env

USER nobody

CMD ["/bin/sh", "../entrypoint.sh"]
EXPOSE 80