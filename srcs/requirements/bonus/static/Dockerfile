# NGINX

FROM debian:bookworm

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/* 
    # remove cached package metadata to keep image lightweight

# copy config file from host to where nginx exects it
COPY ./conf/99-nginx.conf /etc/nginx/conf.d/99-nginx.conf

# BONUS: static site - for eval uncomment port 80 mapping in compose and server block in nginx.conf
COPY ./out /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]