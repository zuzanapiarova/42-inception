FROM debian:bullseye-slim

RUN apt-get update && \ 
    apt-get install -y curl php php4-fpm && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 9000

ENTRYPOINT [ "php-fpm" ]
CMD ["--nodaemonize"]
