# INCEPTION

A 42 project targeted at concepts of virtualization and containerization.
It is a static worpress website served with nginx with mariadb database for storing contents. 

As a bonus, more microservices are added: redis for caching wp data, another website to be served via nginx, and an ftp server (irrelevant to the project).

### Components

The project is created as separate containerized microservices with a docker compose provided to set it up.

containers:
- nginx - web server
- wordpress - 
- mariadb - database
- ftp - bonus, filetransfer
- redis - cache 

volumes:
- volume 1 to store wordpress files (mounted to wordpress and nginx containers)
- volume 2 to store wordpress database (mounted to mariadb)

Wordpress writes files to /var/www/html and is mounted to host, nginx also mounts this to /var/www/html and serves from there.


### HOW TO RUN

**ENVIRONMENT**

Add the following environment variables before running:
DOMAIN_NAME: domain at which the website will be served (<42login>.42.fr)
DB_PORT: port at which db is reachable
WORDPRESS_FILES_PATH: path to dir on host where the wp files are to be mounted
WORDPRESS_DB_PATH: path to dir on host where mariadb data is written
MYSQL_ROOT_PASSWORD: choose
WORDPRESS_DB_NAME: choose
WORDPRESS_DB_USER: choose
WORDPRESS_DB_PASSWORD: choose
WORDPRESS_ADMIN_USER: choose
WORDPRESS_ADMIN_PASSWORD: choose

Generate and add SSL certificates to /srcs/.secrets/ssl:
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout privkey.pem \
  -out fullchain.pem \
  -subj "/CN=<DOMAIN_NAME>"
```
They will be mounted to the nginx container.

**START**

from root:
`make` - will call docker compose up and start att services

**ACCESS**

access domain from env DOMAIN_NAME (https://zpiarova.42.fr:443)
