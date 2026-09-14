# USER DOC

This project runs a small Docker-based web stack with these services:

- Nginx: serves the website over HTTPS and proxies requests to WordPress.
- WordPress: the application layer for the website.
- MariaDB: stores the WordPress database.
- Adminer: web interface for database administration.
- Redis: cache service used by WordPress.
- FTP: optional file upload access to the WordPress site directory.

## Start and Stop

Start the stack from the repository root with:

```bash
make up
```

Stop the containers while keeping the data volumes:

```bash
make down
```

Remove containers and volumes when you want a full cleanup:

```bash
make fclean
```

## Access

**Mandatory**
- Website: `https://<DOMAIN_NAME>`
- WordPress admin panel: `https://<DOMAIN_NAME>/wp-admin`

**Bonus**
- Static site: `http://<DOMAIN_NAME>:80`
- Adminer: `http://<DOMAIN_NAME>:8080`
- cAdvisor: `curl http://<DOMAIN_NAME>:8081/metrics`

Replace `<DOMAIN_NAME>` with the value from `srcs/.env`.

## Evaluation

1. Check all services are down and the volume directories are clean - all should be empty:
```
ls -la /home/zpiarova/data
docker ps -a
docker images -a
```

If not, stop and remove all:
```
docker stop $(docker ps -qa) # stop all running containers
docker rm $(docker ps -qa) # remove all containers
docker rmi $(docker images -qa) # remove all images
docker volume rm $(docker volume ls -q) # remove all volumes
docker network rm $(docker network ls -q) # remove all networks
```

2. Check port forwarding is only for 22(SSH) and 443 (nginx entrypoint) in the VM settings.
3. Clone the repo and cd into it
4. make - will fail if .env is not set up - set up envs based on the template
5. Check containers are running: `docker ps -a`
6. Check volume are set up and are named: `docker volume ls`
7. Check website is up: `curl -vk https://zpiarova.42.fr` (needs -vk because of self signed cert, and heeds https because curl defaults to http)



Bonus: 
1. Static website: `curl zpiarova.42.fr:81` (81 on vm is mapped to 80 on container)