# DEV DOC

## Prerequisites

- Docker Engine
- Docker Compose
- A filled `srcs/.env` file based on `srcs/.env.template`
- The project domain mapped in `/etc/hosts`

## Environment Setup

1. Copy `srcs/.env.template` to `srcs/.env`.
2. Fill in the database, WordPress, FTP, Redis, and runner variables.
3. Make sure the host name in `srcs/.env` points to `127.0.0.1` in `/etc/hosts`.

## Build and Launch

Use the Makefile from the repository root:

```bash
make up
```

This starts the compose stack in detached mode. To rebuild images and prepare the local data directories, use:

```bash
make build
```

## Container Management

- `make up` starts the stack.
- `make down` stops containers and keeps volumes.
- `make clean` stops containers and removes volumes.
- `make fclean` removes volumes and local data directories.
- `make restart` recreates the stack from a clean state.

You can also inspect the stack with:

```bash
docker compose -f srcs/docker-compose.yml ps
```

## Data and Persistence

The compose file uses bind-mounted local directories under `data/`:

- `data/wordpress-data` for MariaDB data.
- `data/wordpress-site` for WordPress files and shared web content.

These directories are created by the Makefile and survive container restarts. Removing them with `make fclean` resets the stored site and database data.
