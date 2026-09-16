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
- Static site: `http://<DOMAIN_NAME>:81`
- Adminer: `http://<DOMAIN_NAME>:8080`
- cAdvisor: `curl http://<DOMAIN_NAME>:8081/metrics`

Replace `<DOMAIN_NAME>` with the value from `srcs/.env`.

## Evaluation

0. SSH into VM so we can run copy-pasted commands (port forwarding must be set up on the VM from 4242 to 22 on host ip 127.0.0.1):
Either in terminal:
1. `ssh -p 4242 zpiarova@localhost` 

Or in vscode window: 
1. Set up vscode for ssh: extension `Remote - SSH: Editing Configuration Files`, then in bottom left corner cick icon `>< (Open a Remote Window)`
2. If there is no `Connect Current Window to Host` in commmand prompt select SSH, add new, and select the config file in /home/.. 
3. Then select `Connect Current Window to Host` and select folder of the VMs cloned repository
4. You can see that it's successfully connected when you see the pop up on the bottom right corner of the screen - Host Added! Source: Remote - SSH (Extension) [Open Config] [Connect]

1. Check all services are down and the volume directories are clean - all should be empty:
```
ls -la /home/zpiarova/data
docker ps -qa
docker images -qa
docker volume ls -q
```
Before starting the evaluation, run this command in the terminal: 
`docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null`

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
4. make - will fail if .env is not set up - set up envs based on the env.example
5. Check containers are running: `docker ps -a`
6. Check volume are set up and are named: `docker volume ls`
7. Check website is up: `curl -vk https://zpiarova.42.fr` (needs -vk because of self signed cert, and heeds https because curl defaults to http)
8. Check firefox website


Bonus: 
1. Static website: `curl zpiarova.42.fr:81` (81 on vm is mapped to 80 on container)
