#!/bin/bash

set -e

if [ -z "$REDIS_PASSWORD" ]; then
    echo "ERROR: REDIS_PASSWORD is not set"
    exit 1
fi

if grep -q '^requirepass ' /etc/redis/redis.conf; then
    sed -i "s/^requirepass .*/requirepass $REDIS_PASSWORD/" /etc/redis/redis.conf
else
    echo "requirepass $REDIS_PASSWORD" >> /etc/redis/redis.conf
fi

echo "Redis configured with password authentication."

exec "$@"