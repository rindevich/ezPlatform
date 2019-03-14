#!/bin/sh

if [ ! -d "./ezplatform" ]
then
    git clone https://github.com/ezsystems/ezplatform ./ezplatform
fi

docker-compose down
docker volume rm docker_nfsmount
docker-compose up -d

WEBSERVER_CONTAINER_ID=$(docker ps -aqf "name=ez-engine")

if [ "$WEBSERVER_CONTAINER_ID" = "" ]
then
    echo "Container is not started."
else
    docker exec -it $WEBSERVER_CONTAINER_ID composer install --optimize-autoloader
    docker exec -it $WEBSERVER_CONTAINER_ID composer ezplatform-install
    docker exec -it $WEBSERVER_CONTAINER_ID bin/console cache:clear --env=dev
    docker exec -it $WEBSERVER_CONTAINER_ID bin/console cache:pool:clear cache.redis
    docker exec -it $WEBSERVER_CONTAINER_ID chown -R www-data:www-data /var/www/ezplatformcache/var
fi