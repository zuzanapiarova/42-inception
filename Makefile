DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml
ENV_FILE = ./srcs/.env
ENV_TEMPLATE = ./srcs/.env.template

-include $(ENV_FILE)
DOMAIN_NAME ?= zpiarova.42.fr

SSL_DIR = ./.keys/ssl
SSL_CERT = $(SSL_DIR)/fullchain.pem
SSL_KEY = $(SSL_DIR)/privkey.pem

all: check-env check-hosts build

check-env:
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

check-hosts:
# 	DEV off / PROD on
# 	@if ! grep -Eq "^[[:space:]]*127\\.0\\.0\\.1[[:space:]]+$(DOMAIN_NAME)([[:space:]]|$$)" /etc/hosts; then \
# 		echo "Adding $(DOMAIN_NAME) to /etc/hosts"; \
# 		if command -v sudo >/dev/null 2>&1; then \
# 			echo "127.0.0.1 $(DOMAIN_NAME)" | sudo tee -a /etc/hosts >/dev/null; \
# 		elif [ "$$(id -u)" -eq 0 ]; then \
# 			echo "127.0.0.1 $(DOMAIN_NAME)" >> /etc/hosts; \
# 		else \
# 			echo "Error: $(DOMAIN_NAME) is not in /etc/hosts."; \
# 			echo "Run: echo '127.0.0.1 $(DOMAIN_NAME)' | sudo tee -a /etc/hosts"; \
# 			exit 1; \
# 		fi; \
# 	fi

# prepare data directories, build and start
build: check-env check-hosts certs
	mkdir -p ${DATA_DIR}/wordpress-data
	mkdir -p ${DATA_DIR}/wordpress-site

# DEV off / PROD on
# recursively make group 33 (www-data group on ubuntu servers used by nginx,php) / group 999 (mysql user group) owner
# 	chown -R 33:33 ${DATA_DIR}/wordpress-data
# 	chown -R 999:999 ${DATA_DIR}/wordpress-site

	docker compose --env-file $(ENV_FILE) -f $(DOCKER_COMPOSE_FILE) build --no-cache
	docker compose --env-file $(ENV_FILE) -f $(DOCKER_COMPOSE_FILE) up -d

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
up: check-env check-hosts certs
	docker compose --env-file $(ENV_FILE) -f $(DOCKER_COMPOSE_FILE) up -d

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

.PHONY: check-env check-hosts certs build up down clean fclean restart all