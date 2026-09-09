#! /bin/bash

set -e

# Create FTP user
if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd -m -d /var/www/html -s /bin/bash "$FTP_USER"
fi

# Set FTP user's password
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

# Configure passive FTP address.
PASV_ADDRESS=${PASV_ADDRESS:-127.0.0.1}
sed -i '/^pasv_address=/d' /etc/vsftpd.conf
echo "pasv_address=$PASV_ADDRESS" >> /etc/vsftpd.conf

# Allow FTP and WordPress to share the mounted directory.
chown -R "$FTP_USER":www-data /var/www/html
chmod -R 775 /var/www/html

exec /usr/sbin/vsftpd /etc/vsftpd.conf