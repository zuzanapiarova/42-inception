#! /bin/bash

set -e

# create FTP user if it doesn't exist - use the WP admin credentials 
if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd -m -d /var/www/html "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

# fix permissions
chown -R www-data:"$FTP_USER" /var/www/html
chmod -R 775 /var/www/html

# start vsftpd in foreground
exec /usr/sbin/vsftpd /etc/vsftpd.conf