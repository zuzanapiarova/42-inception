DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml
ENV_FILE = ./srcs/.env
ENV_TEMPLATE = ./srcs/.env.template

-include $(ENV_FILE)

SSL_DIR = ./srcs/.keys/ssl
SSL_CERT = $(SSL_DIR)/fullchain.pem
SSL_KEY = $(SSL_DIR)/privkey.pem

all: env hosts volumes certs up

env:
	@if [ ! -f "$(ENV_FILE)" ]; then \
		echo "Error: $(ENV_FILE) is missing."; \
		echo "Create it from $(ENV_TEMPLATE) and fill in the required values before running make."; \
		exit 1; \
	fi
	@while IFS= read -r line || [ -n "$$line" ]; do \
		case "$$line" in \
			''|'#'*) ;; \
			*=*) ;; \
			*) echo "Error: invalid env line in $(ENV_FILE): $$line"; echo "Use KEY=value format."; exit 1;; \
		esac; \
	done < "$(ENV_FILE)"

hosts:
	@grep -qF "zpiarova.42.fr" /etc/hosts || \
		echo "127.0.0.1 zpiarova.42.fr" | sudo tee -a /etc/hosts > /dev/null

# prepare data directories
volumes:
	mkdir -p ${DATA_DIR}/wordpress-data
	mkdir -p ${DATA_DIR}/wordpress-site

# DEV off / PROD on
# recursively make group 33 (www-data group on ubuntu servers used by nginx,php) / group 999 (mysql user group) owner
# 	chown -R 33:33 ${DATA_DIR}/wordpress-data
# 	chown -R 999:999 ${DATA_DIR}/wordpress-site

certs:
	@mkdir -p $(SSL_DIR)
	@if [ ! -f "$(SSL_CERT)" ] || [ ! -f "$(SSL_KEY)" ]; then \
		openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
			-keyout "$(SSL_KEY)" \
			-out "$(SSL_CERT)" \
			-subj "/CN=$(DOMAIN_NAME)" \
			-addext "subjectAltName=DNS:$(DOMAIN_NAME),DNS:www.$(DOMAIN_NAME)"; \
	fi

# start
up: volumes
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d --build

# rebuild
re:
	docker compose -f $(DOCKER_COMPOSE_FILE) build --no-cache
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

# stop
down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down

clean:
	docker compose -f $(DOCKER_COMPOSE_FILE) down -v

fclean: clean
	rm -rf ${DATA_DIR}/wordpress-data
	rm -rf ${DATA_DIR}/wordpress-site
	rm -rf $(dir $(SSL_DIR))
	docker system prune -a -f

restart: clean up

.PHONY: env hosts certs build re up down clean fclean restart all