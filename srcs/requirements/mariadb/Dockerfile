# MARIADB

FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/* 
    # Docker optimization - remove cached package metadata to keep image lightweight

# ensure the socket exists even if mariadb is not using it, since mariadb server is looking for it, and chown to mariadb user and group which runs as the mysql user
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld || true

# load config that makes mariadb connect on all interfaces, not only locally on 127.0.0.1 (default)- without this, other containers cannot reach it even if in same Docker network
COPY ./tools/99-docker.cnf /etc/mysql/mariadb.conf.d/99-docker.cnf
# RUN sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

EXPOSE 3307

COPY ./tools/01-db-init.sh /
RUN chmod +x /01-db-init.sh

# run init script with readiness check that waits until db is initialized so wordpress container wont start until DB is
CMD ["/01-db-init.sh", "mariadbd", "--console", "--user=mysql"]