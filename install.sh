#!/usr/bin/env bash

echo "[01] Clone Submodule ZStore\n";
git submodule update --init --recursive

echo "[02] Builde Docker Containers\n";
docker-compose up -d --build

echo "[03] Install Project Dependencies\n";
docker-compose run --rm php-apache composer install

echo "[04] Import Database Structure\n";
cat ./zstore/db/db.sql | docker-compose exec -T mariadb mysql -uroot -proot zstore.dev

echo "[05] Import Project Data\n";
cat ./zstore/db/initdata.sql | docker-compose exec -T mariadb mysql -uroot -proot zstore.dev