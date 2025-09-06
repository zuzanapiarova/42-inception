# STATIC SITE

FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/* 

# remove default nginx static content
RUN rm -rf /usr/share/nginx/html/*

COPY ./out /usr/share/nginx/html

COPY ./conf /etc/nginx/conf.d

EXPOSE 80

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]