# REDIS

FROM debian:bullseye

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

COPY ./scripts/01-entrypoint.sh /usr/local/bin/01-entrypoint.sh
RUN chmod +x /usr/local/bin/01-entrypoint.sh

ENTRYPOINT ["01-entrypoint.sh"]
CMD ["redis-server", "/etc/redis/redis.conf"]

# FROM debian:bullseye

# RUN apt-get update -y && \
#     apt-get install -y redis && \
#     apt-get install -y redis-server

# # redis cannot read extra config files, cant provide config file
# # without this, only connections from inside the container will work - now redis listens on 0.0.0.0 = all network interfaces - containers or host machine can connect    
# RUN sed -i 's/# bind 127.0.0.1/bind 0.0.0.0/g' /etc/redis/redis.conf

# # configure Redis to run in the foreground (needed for Docker)
# RUN sed -i 's/^supervised .*/supervised no/' /etc/redis/redis.conf && \
#     sed -i 's/^dir .*/dir \/data/' /etc/redis/redis.conf && \
#     sed -i "s/^# requirepass .*/requirepass ${REDIS_PASSWORD}/" /etc/redis/redis.conf

# # prevents Redis from using all available RAM on host by limiting memory usage to 256 MB and sets eviction policy to remove least-recently-used keys when Redis reaches memory limit
# RUN echo 'maxmemory 256mb' >> /etc/redis/redis.conf && \ 
#    echo 'maxmemory-policy allkeys-lru' >> /etc/redis/redis.conf

# # allow memory overcommit, which Redis recommends for performance - during peak
# RUN echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf

# EXPOSE 6379

# CMD ["redis-server", "--protected-mode", "no"]