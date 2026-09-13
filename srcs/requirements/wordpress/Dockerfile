# WORDPRESS

FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-zip \
    curl \
    vim \
    mariadb-client \
    php8.2-redis && \
    rm -rf /var/lib/apt/lists/*

# PHP-FPM configuration
RUN sed -i \
    -e 's|^listen = .*|listen = 9000|' \
    -e 's|^;*clear_env = .*|clear_env = no|' \
    -e 's|^;*catch_workers_output = .*|catch_workers_output = yes|' \
    /etc/php/8.2/fpm/pool.d/www.conf

# PHP-FPM daemon uses PID file to record PID of its master process
RUN mkdir -p /run/php 

# download WP-CLI to enable initialization of WordPress without manual browser setup
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

# download WordPress core files into /var/www/html
RUN wp core download --allow-root

# USER TODO - should i add user here ? 

COPY ./tools/01-setup.sh /
RUN chmod +x /01-setup.sh

EXPOSE 9000

ENTRYPOINT ["/01-setup.sh"]
CMD ["/usr/sbin/php-fpm8.2", "-F"]