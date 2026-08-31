# NGINX

FROM debian:bullseye

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/* 
    # remove cached package metadata to keep image lightweight

# mount config file from host to /etc/nginx/conf.d/
COPY ./conf/99-nginx.conf /etc/nginx/conf.d/99-nginx.conf

# for serving static site  - TODO: do i want to mount it or copy it? 
COPY ./out /usr/share/nginx/html

EXPOSE 80
EXPOSE 443

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]