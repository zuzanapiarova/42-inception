# NGINX

FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/* 
    # remove cached package metadata to keep image lightweight

EXPOSE 443

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]