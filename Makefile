DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

# local dev
DATA_DIR = ./data

# prod / VM
# DATA_DIR = /home/zpiarova/data

# prepare data directories, build and start
build: 
	mkdir -p ${DATA_DIR}/wordpress-data
	mkdir -p ${DATA_DIR}/wordpress-site
# 	mkdir -p ${DATA_DIR}/github-actions

	sudo chown -R 33:33 ${DATA_DIR}/wordpress-data
	sudo chown -R 999:999 ${DATA_DIR}/wordpress-site

	docker compose -f $(DOCKER_COMPOSE_FILE) build --no-cache
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

# start
up: 
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

# stop
down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down

# bonus: TODO - make the bonus command here so normal build builds just the requirements and make bonus composes all including bonus?

clean:
	docker compose -f $(DOCKER_COMPOSE_FILE) down -v

fclean: clean
	rm -rf ${DATA_DIR}/wordpress-data
	rm -rf ${DATA_DIR}/wordpress-site
	docker system prune -a -f

restart: clean up

.PHONY: build up down clean fclean restart