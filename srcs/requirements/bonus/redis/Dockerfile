FROM debian:bullseye

RUN apt-get update -y && \
    apt-get install -y redis && \
    apt-get install -y redis-server

# without this, only connections from inside the container will work - now redis listens on 0.0.0.0 = all network interfaces - containers or host machine can connect    
RUN sed -i 's/# bind 127.0.0.1/bind 0.0.0.0/g' /etc/redis/redis.conf

# configure Redis to run in the foreground (needed for Docker)
RUN sed -i 's/^supervised .*/supervised no/' /etc/redis/redis.conf && \
    sed -i 's/^dir .*/dir \/data/' /etc/redis/redis.conf && \
    sed -i "s/^# requirepass .*/requirepass ${REDIS_PASSWORD}/" /etc/redis/redis.conf

# prevents Redis from using all available RAM on host by limiting memory usage to 256 MB and sets eviction policy to remove least-recently-used keys when Redis reaches memory limit
RUN echo 'maxmemory 256mb' >> /etc/redis/redis.conf && \ 
   echo 'maxmemory-policy allkeys-lru' >> /etc/redis/redis.conf

# allow memory overcommit, which Redis recommends for performance - during peak
RUN echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf

EXPOSE 6379

CMD ["redis-server", "--protected-mode", "no"]