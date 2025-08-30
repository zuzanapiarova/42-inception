# MARIADB

FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/* 
    # remove cached package metadata to keep image lightweight

# ensure the socket exists even if mraiadb is not using it, since mariadb server is looking for it 
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# make sure it can connect on ll interfaces, not only locally on 127.0.0.1 - without this, other containers cannot reach it even if in same Docker network
RUN sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# WORKDIR .

COPY ./tools/db-init.sh .

RUN chmod +x db-init.sh

EXPOSE 3306

ENTRYPOINT ["/db-init.sh"]
CMD ["mysqld_safe", "--console"]