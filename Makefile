DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml
ENV_FILE = ./srcs/.env
ENV_EXAMPLE = ./srcs/.env.example

-include $(ENV_FILE)

# .keys are hardcoded here, in docker-compose nginx service and make fclean - always relative to data dir env
SSL_DIR = ${DATA_DIR}/.keys
SSL_CERT = $(SSL_DIR)/fullchain.pem
SSL_KEY = $(SSL_DIR)/privkey.pem

all: env hosts volumes certs up

env:
	@if [ ! -f "$(ENV_FILE)" ]; then \
		echo "Error: $(ENV_FILE) is missing."; \
		echo "Create it from $(ENV_EXAMPLE) and fill in the required values before running make. DON'T USE WORD ADMIN IN ADMIN USERNAMES/PASSWORDS OR EVALUATION IS 0. THE WP ADMIN AND USER EMAILS MUST BE DIFFERENT."; \
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
up: env hosts certs volumes
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
	docker rm -f $$(docker ps -qa) 2>/dev/null || true
	docker rmi -f $$(docker images -qa) 2>/dev/null || true
	rm -rf ${DATA_DIR}/.keys
	rmdir -rf ${DATA_DIR}
	docker system prune -a -f

restart: clean up

.PHONY: all env hosts volumes certs up re down clean fclean