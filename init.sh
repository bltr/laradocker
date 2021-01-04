#!/usr/bin/env bash

source .env

docker-compose build

docker-compose run --no-deps php composer create-project --prefer-dist laravel/laravel
rm laravel/docker-compose.yml
mv laravel/{,.[^.]}* .
rmdir laravel
echo '' > README.md
sed -i "/DB_HOST=/c\DB_HOST=${DB_HOST}" .env
sed -i "/DB_DATABASE=/c\DB_DATABASE=${DB_DATABASE}" .env
sed -i "/DB_USERNAME=/c\DB_USERNAME=${DB_USERNAME}" .env
sed -i "/DB_PASSWORD=/c\DB_PASSWORD=${DB_PASSWORD}" .env
echo '/.idea' >> .gitignore

if [ "$(basename $PWD)" != "laradocker" ] ;
then
  rm init.sh

  rm -fr .git
  git init
  git add .
  git commit -m 'Initial commit'
fi