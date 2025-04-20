#!/usr/bin/env bash

source .env

sed -i "s/_PHP_IMAGE_VERSION_/${PHP_IMAGE_VERSION}/" docker/php/Dockerfile
sed -i "s/_NGINX_IMAGE_VERSION_/${NGINX_IMAGE_VERSION}/" ./docker-compose.yml
sed -i "s/_POSTGRES_IMAGE_VERSION_/${POSTGRES_IMAGE_VERSION}/" ./docker-compose.yml
sed -i "s/_MYSQL_IMAGE_VERSION_/${MYSQL_IMAGE_VERSION}/" ./docker-compose.yml
sed -i "s/_REDIS_IMAGE_VERSION_/${REDIS_IMAGE_VERSION}/" ./docker-compose.yml
sed -i "s/_NGINX_PORT_/${NGINX_PORT}/" ./docker-compose.yml
sed -i "s/_MYSQL_PORT_/${MYSQL_PORT}/" ./docker-compose.yml
sed -i "s/_MYSQL_TEST_PORT_/${MYSQL_TEST_PORT}/" ./docker-compose.yml
sed -i "s/_POSTGRES_PORT_/${POSTGRES_PORT}/" ./docker-compose.yml
sed -i "s/_POSTGRES_TEST_PORT_/${POSTGRES_TEST_PORT}/" ./docker-compose.yml
sed -i "s/_REDIS_PORT_/${REDIS_PORT}/" ./docker-compose.yml

docker compose build

docker compose run --no-deps --rm php composer create-project --no-scripts --prefer-dist laravel/laravel

mv laravel/* .
mv laravel/.* .
rmdir laravel

echo '' > README.md

sed -i "/APP_URL=/c\APP_URL=http://localhost:${NGINX_PORT}" .env.example

sed -i "/DB_CONNECTION=/c\DB_CONNECTION=pgsql" .env.example
sed -i "/DB_HOST=/c\DB_HOST=${DB_HOST}" .env.example
sed -i "/DB_DATABASE=/c\DB_DATABASE=${DB_DATABASE}" .env.example
sed -i "/DB_USERNAME=/c\DB_USERNAME=${DB_USERNAME}" .env.example
sed -i "/DB_PASSWORD=/c\DB_PASSWORD=${DB_PASSWORD}" .env.example

echo >> .env.example
echo "COMPOSE_BAKE=true" >> .env.example

if [ "$(basename $PWD)" != "laradocker" ]; then
  rm init.sh
  rm .env
  rm -fr .git

  git init
  git add .
  git commit -m 'Initial commit'
fi
