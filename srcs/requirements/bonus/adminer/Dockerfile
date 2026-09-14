# ADMINER

FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    apache2 \
    php8.2 \
    libapache2-mod-php8.2 \
    php8.2-curl \
    php8.2-cli \
    php8.2-mysql \
    php8.2-gd \
    wget

WORKDIR /var/www/html

RUN wget "http://www.adminer.org/latest.php" -O /var/www/html/adminer.php && \
    chown -R www-data:www-data /var/www/html/adminer.php && \
    chmod 755 -R /var/www/html/adminer.php && rm -rf index.html
    
RUN sed -i "s/Listen 80/Listen 8080/g" /etc/apache2/ports.conf

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]