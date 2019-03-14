# Dockerize ezPlatform for Mac OS Developers
The main idea was create very fast and simple installtaion for [ezPlatform 2.x](https://www.ezplatform.com). 
1. For Mac 18.03 we can directly mount the host as a volume from the container. NFS
2. Store ezPltafrom/Symfony caches/logs in the container, excluded from mounted volumes (!)
2. Persistence cache and sessions uses Redis.

## Requirements
- Docker Engine 18.03+
- Mac OS X

## Set Up Docker For Mac with Native NFS

The bash script (should be started on first) to ensure NFS is configured correctly on your Mac: ```./docker/nfs_docker_osx.sh```

I basically fork its post at [Native NFS for Mac](https://medium.com/@sean.handley/how-to-set-up-docker-for-mac-with-native-nfs-145151458adc)

##  Images
This repository contains:
- Nginx 1.14.2 [Alpine Linux]
http://localhost:8080
- PHP 7.3.3 (FPM) + Zend OPcache
- MariaDB 10.4
- Solr 6.6.5 [Alpine Linux] http://localhost:8983
- Mailcatcher 0.6.4 [Alpine Linux]
http://localhost:1080
- Redis 5 [Alpine Linux]
- redis Commander [Alpine Linux]
http://localhost:8081
- phpMyAdmin
http://localhost:8899

## Redis
Persistence cache and sessions uses Redis.
For clear cache please use right command:
```bash 
php bin/console cache:pool:clear cache.redis
```

## Usage
For first initialization of Project please use:
```bash
 ./initial_setup.sh
```

## Copyright
Copyright [Etecture GmbH](http://etecture.de/), 2019