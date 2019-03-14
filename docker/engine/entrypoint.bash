#!/usr/bin/env bash
cd /var/www/html

ORIGPASSWD=$(cat /etc/passwd | grep www-data)
ORIG_UID=$(echo "$ORIGPASSWD" | cut -f3 -d:)
ORIG_GID=$(echo "$ORIGPASSWD" | cut -f4 -d:)
ORIG_HOME=$(echo "$ORIGPASSWD" | cut -f6 -d:)
DEV_UID=${DEV_UID:=$ORIG_UID}
DEV_GID=${DEV_GID:=$ORIG_GID}

if [ "$DEV_UID" -ne "$ORIG_UID" ] || [ "$DEV_GID" -ne "$ORIG_GID" ]; then
    groupmod -g "$DEV_GID" www-data
    usermod -u "$DEV_UID" -g "$DEV_GID" www-data
fi

chown www-data:www-data /var/www/html

if [ -d /var/www/html/var/cache ]; then
    rm -rf /var/www/html/var/cache
    rm -rf $SYMFONY_TMP_DIR/var/cache
    chown -R www-data:www-data /var/www/html/var/logs
    chown -R www-data:www-data /var/www/html/web
fi

composer self-update
chown -R www-data:www-data $SYMFONY_TMP_DIR/var

exec "$@"