#!/bin/bash

set -eu

# TODO: paths as /blabla resolve to index, must change to return 404

# Debian's PHP-FPM package normally runs its worker pool as www-data.
# The WordPress volume needs to be writable by PHP-FPM.
chown -R www-data:www-data /var/www/html || true

# --------------------------------------------
# Configure WordPress via wp-config.php
# --------------------------------------------

if [ ! -f /var/www/html/wp-config.php ]; then
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root \
        --skip-check
fi

# --------------------------------------------
# Install WordPress if it is not installed
# --------------------------------------------

if ! wp core is-installed --allow-root; then
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="INCEPTION" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --allow-root
    echo "WordPress core installed."
fi

# --------------------------------------------
# Create additional WordPress user if missing
# --------------------------------------------

if ! wp user get "$WORDPRESS_USER" --field=ID --allow-root >/dev/null 2>&1; then
    wp user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
        --role=author \
        --user_pass="$WORDPRESS_USER_PASSWORD" \
        --allow-root
    echo "WordPress user created."
fi

# --------------------------------------------
# Create Home page if missing
# --------------------------------------------

HOME_ID=$(wp post list \
    --post_type=page \
    --name=home \
    --field=ID \
    --allow-root)

if [ -z "$HOME_ID" ]; then
    HOME_ID=$(wp post create \
        --post_type=page \
        --post_name=home \
        --post_title="<h4 style='color: #AA336A;'>Home</h4>" \
        --post_content="<h1 style='color:#FFB6C1;'>Welcome to Inception project by zpiarova - now with github actions</h1>" \
        --post_status=publish \
        --porcelain \
        --allow-root)
    echo "Home page created."
fi

wp option update show_on_front page --allow-root
wp option update page_on_front "$HOME_ID" --allow-root

# --------------------------------------------
# Create Posts page if missing
# --------------------------------------------

BLOG_ID=$(wp post list \
    --post_type=page \
    --name=posts \
    --field=ID \
    --allow-root)

if [ -z "$BLOG_ID" ]; then
    BLOG_ID=$(wp post create \
        --post_type=page \
        --post_name=posts \
        --post_title="<h4 style='color: #AA336A;'>Posts</h4>" \
        --post_status=publish \
        --porcelain \
        --allow-root)
    echo "Posts page created."
fi

wp option update page_for_posts "$BLOG_ID" --allow-root

# --------------------------------------------
# Create blog posts if missing
# --------------------------------------------

if ! wp post list --post_type=post --name=first-post --field=ID --allow-root | grep -q .; then
    wp post create \
        --post_type=post \
        --post_name=first-post \
        --post_title="<h4 style='color: #AA336A;'>First Post</h4>" \
        --post_content="<p style='color:#FFB6C1;'>This is the first blog post.</p>" \
        --post_status=publish \
        --post_author=1 \
        --allow-root
fi

if ! wp post list --post_type=post --name=second-post --field=ID --allow-root | grep -q .; then
    wp post create \
        --post_type=post \
        --post_name=second-post \
        --post_title="<h4 style='color: #AA336A;'>Second Post</h4>" \
        --post_content="<p style='color:#FFB6C1;'>This is the second blog post.</p>" \
        --post_status=publish \
        --post_author=1 \
        --allow-root
fi

if ! wp post list --post_type=post --name=third-post --field=ID --allow-root | grep -q .; then
    wp post create \
        --post_type=post \
        --post_name=third-post \
        --post_title="<h4 style='color: #AA3366;'>Third Post</h4>" \
        --post_content="<p style='color:#FFB6C1;'>This is the third blog post.</p>" \
        --post_status=publish \
        --post_author=1 \
        --allow-root
    echo "Posts setup complete."
fi


# --------------------------------------------
# BONUS - Redis
# --------------------------------------------

if ! wp plugin is-installed redis-cache --allow-root; then
    wp plugin install redis-cache --activate --allow-root
fi

wp plugin activate redis-cache --allow-root

wp config set WP_REDIS_HOST "$WP_REDIS_HOST" --allow-root
wp config set WP_REDIS_PORT "$WP_REDIS_PORT" --allow-root
wp config set WP_REDIS_PASSWORD "$WP_REDIS_PASSWORD" --allow-root
wp config set WP_REDIS_DATABASE 0 --allow-root
wp config set WP_CACHE true --raw --allow-root

if ! wp redis status --allow-root 2>/dev/null | grep -q "Status: Connected"; then
    wp redis enable --allow-root
    echo "Redis enabled."
fi


# --------------------------------------------
# Start PHP-FPM
# --------------------------------------------

exec "$@"