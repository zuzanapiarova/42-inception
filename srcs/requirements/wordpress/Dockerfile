# WORDPRESS

FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-zip \
    curl \
    mariadb-client \
    sendmail \
    vim

# replaces so that PHP-FPM listens on TCP port 9000 instead of a Unix socket which only works inside the same container
RUN sed -i -e 's/listen =.*/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

# PHP-FPM needs a runtime directory for its socket file (if using a Unix socket) and PID file.Without this directory, PHP-FPM may fail to start because it cannot write its socket or PID file
RUN mkdir -p /run/php 

# set working directory for subsequent commands - /var/www/html is the document root where WordPress files live.
WORKDIR /var/www/html

# changes owner and group of /var/www/html to www-data ( default user PHP-FPM runs as) because PHP-FPM needs write access for certain operations (uploads, cache, plugins)
RUN chown -R www-data:www-data /var/www/html

# Downloads WP-CLI from GitHub, makes it executable, moves it to /usr/local/bin/wp so it’s in the PATH and can be run anywhere - so we can initialize WordPress without manual browser setup
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# use WP-CLI to download WordPress core files into /var/www/html, --allow-root is required because in Docker builds you are usually running as root
RUN wp core download --allow-root

COPY ./tools/wp-setup.sh .

RUN chmod +x wp-setup.sh

EXPOSE 9000

ENTRYPOINT ["bash", "wp-setup.sh"]

    # php-redis \
    #sed -i -e 's/;listen.owner = www-data/listen.owner = www-data/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    #sed -i -e 's/;listen.group = www-data/listen.group = www-data/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    #sed -i -e 's/;listen.mode = 0660/listen.mode = 0660/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    #sed -i -e 's/;clear_env = no/clear_env = no/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    #sed -i -e 's/;catch_workers_output = yes/catch_workers_output = yes/g' /etc/php/7.3/fpm/pool.d/www.conf && \
