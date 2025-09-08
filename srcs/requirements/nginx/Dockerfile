# NGINX

FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/* 
    # remove cached package metadata to keep image lightweight

# it will mount host volume to /var/www/html in container

# it will also mount the config file from host to /etc/nginx/conf.d/
# COPY ./conf /etc/nginx/conf.d

# for serving static site 
COPY ./out /usr/share/nginx/html

EXPOSE 80
EXPOSE 443

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]




