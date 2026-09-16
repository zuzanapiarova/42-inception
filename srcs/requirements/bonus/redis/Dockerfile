# REDIS

FROM debian:bookworm

RUN apt-get update -y && \
    apt-get install -y redis-server

# change redis config file - it cant read extra config files
RUN sed -i 's/^bind .*/bind 0.0.0.0/' /etc/redis/redis.conf && \
    sed -i 's/^protected-mode .*/protected-mode no/' /etc/redis/redis.conf && \
    sed -i 's/^daemonize .*/daemonize no/' /etc/redis/redis.conf && \
    sed -i 's/^supervised .*/supervised no/' /etc/redis/redis.conf && \
    sed -i 's/^dir .*/dir \/data/' /etc/redis/redis.conf && \
    mkdir -p /data && \
    echo 'maxmemory 256mb' >> /etc/redis/redis.conf && \
    echo 'maxmemory-policy allkeys-lru' >> /etc/redis/redis.conf

RUN echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf

EXPOSE 6379

COPY ./scripts/01-init.sh /usr/local/bin/01-init.sh
RUN chmod +x /usr/local/bin/01-init.sh

CMD ["01-init.sh", "redis-server", "/etc/redis/redis.conf"]