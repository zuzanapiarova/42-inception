FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/* 
    # remove cached package metadata to keep image lightweight

EXPOSE 3306

ENTRYPOINT ["mysqld"]
CMD ["--console"]