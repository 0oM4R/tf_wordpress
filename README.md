# grid3_Wordpress

Get Wordpress up and running on grid3.

This image Based on php:8.0-apache which is also Debian based.

## What in this image

- Wordpress 6.1.1
- MySQL 8.0.32-1debian11
- wp-cli
- include preinstalled openssh-client, openssh-server, curl, wget, iproute2, and some other packages.
- modified apache roles to avoid mixed-content error.
- ufw with restricted rules applied.
- zinit process manager which is configured with these services:
  
  - sshd: starting OpenSSH server daemon
  - ssh_config: Add the user SSH key to authorized_keys, so he can log in remotely to the host which running this image.
  - ufw-init: define restricted firewall/iptables rules.
  - ufw: apply the pre-defined firewall rules
  - mysql: configure and run the MySQL server.
  - wp: configure Wordpress and perform Wordpress installation using `wp core install`

## Building

in the grid3/wordpress directory

`docker build -t {user|org}/grid3_taiga_docker:latest .`

## Deploying on grid 3

### convert the docker image to Zero-OS flist

Easiest way to convert the docker image to Flist is using [Docker Hub Converter tool](https://hub.grid.tf/docker-convert), make sure you already built and pushed the docker image to docker hub before using this tool.

### Deploying

Easiest way to deploy a VM using the flist is to head to to our [playground](https://play.grid.tf) and deploy a Virtual Machine by providing this flist URL.

> make sure to provide the correct entrypoint, and required env vars.

or use the dedicated Wordpress weblet if available, which will deploy an instance that satisfies the above perquisites.

> TODO: add terraform example file

### Entrypoint

- `/sbin/zinit init`

### Required Env Vars

- `SSH_KEY`: User SSH public key.
- `MYSQL_USER`: this will be used as a global username for MySQL WordPress, and WP-CLI.
- `MYSQL_PASSWORD`: will be used as a global password for MySQL, WordPress, and WP-CLI.
- `ADMIN_EMAIL`: this will be used in WP_CLI website installation
- `WP_URL`: this will be used in WP_CLI website installation.

> Those ENVs and some other ENV that not required; if the user provides them they will get overwritten, for example
    - `MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-test}`
    - `MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}`
> **This approach is used for all the essential envs in case the user never provide them**

### Optional Env Vars

#### MySQL

- `MYSQL_ROOT_PASSWORD`: specifies the password that will be set for the MySQL root superuser account.
  - _Default_: `test`
- `MYSQL_DATABASE`: allows you to specify the name of a database to be created on image startup.
  - _Default_: `wordpress`
- `MYSQL_USER`, `MYSQL_PASSWORD`: used in conjunction to create a new user and to set that user's password.
  - _Default_: `MYSQL_USER: wordpress`,`MYSQL_PASSWORD: password`.

#### Wordpress

> Authentication-related envs in WordPress are set to the same values in MySQL. see [Required](./README.md#required-env-vars) section.

- `WORDPRESS_DB_HOST`= the database host address.
  - _Default_: `172.0.0.1`
- `WORDPRESS_DB_USER` = `MYSQL_USER`
- WORDPRESS_DB_PASSWORD= `MYSQL_PASSWORD`
- WORDPRESS_DB_NAME= `MYSQL_DATABASE_NAME`
- WORDPRESS_TABLE_PREFIX= database tables prefix
  - _Default_: `wp_`
  
For full list of the ENV vars check the official [Wordpress](https://hub.docker.com/_/wordpress) and [MySQL](https://hub.docker.com/_/mysql) Docker images
