DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

# local dev
DATA_DIR = ./data
# todo: change to prod  location 
# prod / VM
# DATA_DIR = /home/zpiarova/data

DOMAIN_NAME ?= zpiarova.42.fr

SSL_DIR = ./.keys/ssl. # todo: now we have 2 times ssl keys ?
SSL_CERT = $(SSL_DIR)/fullchain.pem
SSL_KEY = $(SSL_DIR)/privkey.pem

certs:
	@mkdir -p $(SSL_DIR)
	@if [ ! -f "$(SSL_CERT)" ] || [ ! -f "$(SSL_KEY)" ]; then \
		openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
			-keyout "$(SSL_KEY)" \
			-out "$(SSL_CERT)" \
			-subj "/CN=$(DOMAIN_NAME)" \
			-addext "subjectAltName=DNS:$(DOMAIN_NAME),DNS:www.$(DOMAIN_NAME)"; \
	fi

# prepare data directories, build and start
build: certs
	mkdir -p ${DATA_DIR}/wordpress-data
	mkdir -p ${DATA_DIR}/wordpress-site
# 	mkdir -p ${DATA_DIR}/github-actions

	sudo chown -R 33:33 ${DATA_DIR}/wordpress-data
	sudo chown -R 999:999 ${DATA_DIR}/wordpress-site

	docker compose -f $(DOCKER_COMPOSE_FILE) build --no-cache
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

# start
up: certs
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

# stop
down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down

clean:
	docker compose -f $(DOCKER_COMPOSE_FILE) down -v

fclean: clean
	rm -rf ${DATA_DIR}/wordpress-data
	rm -rf ${DATA_DIR}/wordpress-site
	rm -rf $(SSL_DIR)
	docker system prune -a -f

restart: clean up

.PHONY: certs build up down clean fclean restart