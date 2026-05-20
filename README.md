# Inception

A Docker-based infrastructure project from the 42 school curriculum. The goal is to set up a small web stack using Docker Compose, with each service running in its own container built from scratch on Debian Bullseye.

---

## About

Inception deploys a WordPress website served over HTTPS, backed by a MariaDB database, all orchestrated with Docker Compose. Every container is built from a custom Dockerfile — no pre-built images like `wordpress:latest` or `mysql:latest` allowed.

---

## Architecture

```
Client (HTTPS :443)
        │
        ▼
   [ NGINX ]  ← TLS termination (TLSv1.2 / TLSv1.3)
        │
        ▼
  [ WordPress ]  ← PHP-FPM on port 9000
        │
        ▼
  [ MariaDB ]  ← port 3306
```

**Volumes:**
- `wordpress_data` → `/home/login/data/wordpress` — WordPress files
- `db_data` → `/home/login/data/mariadb` — MariaDB data

**Network:** all containers share a custom bridge network (`my_network`).

---

## Services

### NGINX
- Built on `debian:bullseye`
- Serves HTTPS only on port `443`
- Self-signed SSL certificate generated at container startup with OpenSSL
- Proxies PHP requests to WordPress via FastCGI

### WordPress
- Built on `debian:bullseye`
- Runs PHP-FPM 7.4 listening on `0.0.0.0:9000`
- Uses WP-CLI to download WordPress core, create config, install the site, and create users on first run
- Waits for MariaDB to be ready before starting

### MariaDB
- Built on `debian:bullseye`
- Initializes the database, user, and privileges on first run via a shell script
- Bound to `0.0.0.0:3306` (internal network only — port not exposed externally)

---

## Configuration

All secrets and settings live in `srcs/.env`:

```env
MYSQL_DATABASE=wordpress
MYSQL_USER=login
MYSQL_PASSWORD=123
MYSQL_ROOT_PASSWORD=123

TITLE=Site
DB_HOST=mariadb
DB_HOST_PORT=3306
DOMAIN_NAME=https://login.42.fr

ADMIN_USER=login
ADMIN_USER_PASSWORD=2025
ADMIN_USER_EMAIL=login@gmail.com

SECOND_USER=second
SECOND_USER_PASSWORD=0000
SECOND_USER_EMAIL=second@gmail.com
```

> **Note:** replace all credentials before deploying. The `.env` file should never be committed to version control.

---

## Usage

```bash
make          # create data dirs, build images, start containers
make build    # build images only
make up       # start containers
make down     # stop containers
make clean    # stop and remove containers + volumes
make fclean   # full cleanup: containers, volumes, images, data dirs
make re       # fclean + all
make logs     # tail container logs
make ps       # list running containers
```

---

## Project Structure

```
inception/
├── Makefile
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/config.conf      # NGINX server block
        │   └── tools/script.sh      # SSL cert generation + nginx start
        ├── wordpress/
        │   ├── Dockerfile
        │   └── tools/script.sh      # WP-CLI setup + php-fpm start
        └── mariadb/
            ├── Dockerfile
            ├── conf/50-server.cnf   # MariaDB bind/port config
            └── tools/script.sh      # DB init + mysqld_safe start
```

---

## Requirements

- Docker and Docker Compose
- Linux (data volumes use bind mounts to `/home/login/data/`)
- `sudo` access for removing data directories on `fclean`
