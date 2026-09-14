#! /bin/bash

set -e

# Ensure MariaDB can write to the mounted data directory.
mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Start MariaDB in the background
mariadbd --skip-networking --user=mysql &

# store mariadb pid to stop it later
MYSQL_PID=$!

# Internal startup guard so MariaDB does not continue until it is really ready
MAX_WAIT_SECONDS=30
WAITED_SECONDS=0
until mysqladmin ping &>/dev/null; do
    if [ "$WAITED_SECONDS" -ge "$MAX_WAIT_SECONDS" ]; then
        echo "Error: MariaDB did not become ready within ${MAX_WAIT_SECONDS} seconds."
        kill "$MYSQL_PID"
        exit 1
    fi
    echo "Waiting for MariaDB to start..."
    sleep 1
    WAITED_SECONDS=$((WAITED_SECONDS + 1))
done

# create db
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
echo "DB created"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" # % means this user can connect from any IP address or host
echo "user created"
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';" # 
echo "user granted access"

echo "Database and user created"

# Stop background server and start in foreground
kill $MYSQL_PID
exec "$@"