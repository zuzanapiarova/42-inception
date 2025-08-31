#! /bin/bash

set -e 

# only run setup if WordPress hasn’t been configured yet - checks if setup file wp-config.php exists in /var/www/html
if [ ! -f /var/www/html/wp-config.php ]; then
    wp config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --allow-root  --skip-check
fi

until wp db check --allow-root; do
    echo "Waiting for database to be ready..."
    sleep 3
done

if ! wp core is-installed --allow-root; then
    # installs WordPress core: sets site URL(--url), ets site title (--title), creates admin account (--admin_user, --admin_password, --admin_email)
    wp core install --url=$DOMAIN_NAME --title="INCEPTION" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --allow-root
    
    # create additional WordPress user
    wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=author --user_pass=$WORDPRESS_USER_PASSWORD --allow-root

    HOME_ID=$(wp post create \
        --post_type=page \
        --post_title="<h4 style='color: #AA336A;'>Home</h4>" \
        --post_content="<h1 style='color:#FFB6C1;'>Welcome to Inception project by zpiarova</h1>" \
        --post_status=publish \
        --porcelain --allow-root) || true

    wp option update show_on_front 'page' --allow-root || true
    wp option update page_on_front $HOME_ID --allow-root || true

    # ---------------------------
    # Create 3 blog posts
    # ---------------------------
    BLOG_ID=$(wp post create \
        --post_type=page \
        --post_title="<h4 style='color: #AA336A;'>Posts</h4>" \
        --post_status=publish \
        --porcelain --allow-root) || true

    wp option update page_for_posts $BLOG_ID --allow-root

    wp post create --post_title="<h4 style='color: #AA336A;'>First Post</h4>" --post_content="<p style='color:#FFB6C1;'> This is the first blog post.</p>" --post_status=publish --post_author=1 --allow-root || true
    wp post create --post_title="<h4 style='color: #AA336A;'>Second Post</h4>" --post_content="<p style='color:#FFB6C1;'>This is the second blog post.</p>" --post_status=publish --post_author=1 --allow-root || true
    wp post create --post_title="<h4 style='color: #AA336A;'>Third Post</h4>" --post_content="<p style='color:#FFB6C1;'>This is the third blog post.</p>" --post_status=publish --post_author=1 --allow-root || true

    echo "landing page setup complete"

    # install redis plugin and set redis connection constants in wp-config.php
    wp plugin install redis-cache --activate --allow-root
    wp config set WP_REDIS_HOST "$WP_REDIS_HOST" --allow-root
    wp config set WP_REDIS_PORT "$WP_REDIS_PORT" --allow-root
    wp config set WP_REDIS_PASSWORD "$WP_REDIS_PASSWORD" --allow-root
    wp config set WP_REDIS_DATABASE 0 --allow-root
    wp redis enable --allow-root
    wp config set WP_CACHE 'true' --allow-root
    echo "redis enabled"

fi

/usr/sbin/php-fpm7.4 -F
