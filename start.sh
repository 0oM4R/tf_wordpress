#!/bin/sh
nohup ./usr/local/bin/docker-entrypoint.sh mysqld --datadir /var/lib/mysql_tmp &
./usr/local/bin/docker-entrypoint.sh apache2-foreground
