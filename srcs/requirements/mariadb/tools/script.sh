#!/bin/bash

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
	echo "Initializing database..."
	
	service mariadb start
	sleep 5
	
	mariadb << EOF
	CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
	CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
	GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
	ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
	FLUSH PRIVILEGES;
EOF
	
	# Kill the process properly
	mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
	sleep 3
fi

echo "Starting MariaDB..."
exec mysqld_safe