#! /bin/bash

set -e

# Start MariaDB in the background
mysqld --skip-networking &
MYSQL_PID=$!

# Wait for the server to be ready
until mysqladmin ping &>/dev/null; do
    echo "Waiting for MariaDB to start..."
    sleep 1
done

mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
echo "DB created"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" # % means this user can connect from any IP address or host
echo "user created"
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';" # 
mysql -e "FLUSH PRIVILEGES;"
echo "user granted access"

echo "Database and user created"

# Stop background server and start in foreground
kill $MYSQL_PID
exec mysqld --console
