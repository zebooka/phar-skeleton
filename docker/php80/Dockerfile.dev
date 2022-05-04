FROM php:8.0-fpm-alpine
COPY --from=composer:2.3 /usr/bin/composer /usr/bin/composer
RUN apk add git
WORKDIR /app
