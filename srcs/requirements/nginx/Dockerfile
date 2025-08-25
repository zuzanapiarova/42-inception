FROM debian:bullseye-slim

RUN apt-get update &&\
    apt-get install -y nginx &&\
    rm -rf /var/lib/apt/lists/* 
    # remove cached package metadata to keep image lightweight

# COPY IN MY CONFIG FILES  
COPY ./conf/nginx.conf /etc/nginx/conf.d

EXPOSE 443

ENTRYPOINT [ "nginx" ]
CMD ["-g", "daemon-off;"]