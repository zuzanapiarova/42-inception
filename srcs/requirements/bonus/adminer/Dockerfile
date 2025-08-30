# ADMINER

FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    apache2 \
    php7.4 \
    libapache2-mod-php\
    php7.4-curl \
    php7.4-cli \
    php7.4-mysql \
    php-gd \
    mariadb-server \ 
    wget

WORKDIR /var/www/html
RUN wget "http://www.adminer.org/latest.php" -O /var/www/html/adminer.php && \
    chown -R www-data:www-data /var/www/html/adminer.php && \
    chmod 755 -R /var/www/html/adminer.php && rm -rf index.html
    
RUN sed -i "s/Listen 80/Listen 8080/g" /etc/apache2/ports.conf
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]