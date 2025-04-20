FROM php:_PHP_IMAGE_VERSION_

ENV COMPOSER_HOME='/composer'

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
COPY --from=composer /usr/bin/composer /usr/bin

RUN set -ex \
    && install-php-extensions \
        pdo_mysql \
        pdo_pgsql \
        zip \
        pcntl \
    && mkdir $COMPOSER_HOME \
    && chmod -R 0777 $COMPOSER_HOME

WORKDIR /app