FROM debian:bullseye-slim

# get ARGs from compose or default to these values
ARG DOMAIN_NAME=zpiarova.42.fr 
ARG NGINX_HOST_PORT=443

RUN apt-get update && \
    apt-get install -y nginx gettext-base && \
    rm -rf /var/lib/apt/lists/* 

COPY ./conf/nginx.conf.template /etc/nginx/templates/nginx.conf.template

RUN envsubst '$DOMAIN_NAME' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/conf.d

EXPOSE $NGINX_HOST_PORT

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]