#!bin/bash

sleep 10

# setting up WordPress via WP-CLI automatically instead of manually in the browser

# only run  setup if WordPress hasn’t been configured yet - checks if setup file wp-config.php exists in /var/www/html
if [ ! -f /var/www/html/wp-config.php ]; then
    wp config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER \
        --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --allow-root  --skip-check
    
    # installs WordPress core: sets site URL(--url), ets site title (--title), creates admin account (--admin_user, --admin_password, --admin_email)
    wp core install --url=$DOMAIN_NAME --title="INCEPTION" --admin_user=$WORDPRESS_ADMIN_USER \
        --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL \
        --allow-root
    
    # create additional WordPress user
    wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=author --user_pass=$WORDPRESS_USER_PASSWORD --allow-root

 #   wp config  set WP_DEBUG true  --allow-root

    # wp config set FORCE_SSL_ADMIN 'false' --allow-root

    # wp config  set WP_REDIS_HOST $redis_host --allow-root

    # wp config set WP_REDIS_PORT $redis_port --allow-root

    # wp config  set WP_CACHE 'true' --allow-root

    # wp plugin install redis-cache --allow-root

    # wp plugin activate redis-cache --allow-root

    # wp redis enable --allow-root

    chown -R www-data:www-data /var/www/html/wp-content
    chmod -R 755 /var/www/html/wp-content

    # install theme

    wp theme install twentyfifteen

    wp theme activate twentyfifteen

    wp theme update twentyfifteen
fi

/usr/sbin/php-fpm7.4 -F