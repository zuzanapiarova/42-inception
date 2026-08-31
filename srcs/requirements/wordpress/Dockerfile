# WORDPRESS

FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-zip \
    curl \
    vim \
    mariadb-client \
    php-redis && \
    rm -rf /var/lib/apt/lists/*
    # sendmail \
    # ftp 

# PHP-FPM configuration
COPY ./tools/zzz-docker.conf /etc/php/7.4/fpm/pool.d/zzz-docker.conf

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
CMD ["/usr/sbin/php-fpm7.4", "-F"]