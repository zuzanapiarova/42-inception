DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

# change ip address in vsftpd.conf
build:
	mkdir -p /home/zpiarova/data/wordpress-data
	mkdir -p /home/zpiarova/data/wordpress-site

	sudo chown -R 33:33 /home/zpiarova/data/wordpress-data
	sudo chown -R 999:999 /home/zpiarova/data/wordpress-site

	docker compose $(DOCKER_COMPOSE_FILE) build --no-cache
	docker compose up -d

up: 
	docker compose up -d

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down

clean:
	docker compose -f $(DOCKER_COMPOSE_FILE) down -v

fclean: clean
	rm -rf /home/zpiarova/data/wordpress-data
	rm -rf /home/zpiarova/data/wordpress-site
	docker system prune -a -f

restart: clean up

.PHONY: build up down clean fclean restart