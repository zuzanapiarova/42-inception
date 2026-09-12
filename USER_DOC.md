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

## Credentials

All credentials are defined in `srcs/.env`, created from `srcs/.env.template`.

- WordPress and MariaDB credentials are stored there.
- Adminer uses the same database credentials.
- FTP and Redis credentials are also defined there.

Keep `srcs/.env` private and do not commit it.

## Check Services

You can verify the stack by checking the containers and opening the website.

- List running containers: `docker ps`
- Check a specific container: `docker compose -f srcs/docker-compose.yml ps`
- Test the website in a browser and confirm WordPress loads.
- For Adminer, sign in with the database credentials and connect to host `mariadb`.

If the page does not load, check that the containers are running and that the domain points to `127.0.0.1` in `/etc/hosts`.
