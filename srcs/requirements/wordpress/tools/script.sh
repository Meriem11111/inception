#! /bin/bash

until mysqladmin ping -h"$DB_HOST" -P"$DB_HOST_PORT" --silent; do
#   echo "Waiting for MariaDB..."
  sleep 2
done

echo "MariaDB is ready!"
cd /var/www/html

if [ ! -f /var/www/html/wp-config.php ]; then
	wp core download --allow-root
	wp config create \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="$DB_HOST:$DB_HOST_PORT" \
		--allow-root
fi

if ! wp core is-installed --allow-root; then
	wp core install \
	--url="https://meabdelk.42.fr" \
	--title="$TITLE" \
	--admin_user="$ADMIN_USER" \
	--admin_password="$ADMIN_USER_PASSWORD" \
	--admin_email="$ADMIN_USER_EMAIL" \
	--skip-email \
	--allow-root
fi

echo "Creating second user..."
wp user create $SECOND_USER $SECOND_USER_EMAIL \
		--user_pass=$SECOND_USER_PASSWORD \
		--role=subscriber \
		--allow-root

php-fpm8.2 -F
