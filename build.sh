#!/bin/bash

docker build -t nameless

if [ ! -e mysql_env.sh ]; then
  echo "MYSQL_ROOT_PASSWORD=$(openssl rand -base64 32)" >> mysql_env.sh
  echo 'MYSQL_DATABASE=nameless' >> mysql_env.sh
  echo 'MYSQL_USER=nameless' >> mysql_env.sh
  echo "MYSQL_PASSWORD=$(openssl rand -base64 32)" >> mysql_env.sh
fi

if [ ! -d mysql ]; then
  mkdir mysql
fi

source mysql_env.sh

docker kill nameless-mysql
docker rm nameless-mysql
docker run --name nameless-mysql \
  -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  -e MYSQL_DATABASE=$MYSQL_DATABASE \
  -e MYSQL_USER=$MYSQL_USER \
  -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
  -v $(realpath ./mysql):/var/lib/mysql \
  -d mysql

docker kill nameless
docker rm nameless
docker run \
  --name nameless \
  --link nameless-mysql:mysql \
  -d -p 80:80 -e ALLOW_OVERRIDE=true nameless

sleep 1

eval $(docker exec -it nameless /bin/bash -c 'set' | grep MYSQL)
echo "Database Address: $MYSQL_PORT_3306_TCP_ADDR" 
echo "Database Username: $MYSQL_ENV_MYSQL_USER"
echo "Database Password: $MYSQL_ENV_MYSQL_DATABASE"
echo "Database Name: $MYSQL_ENV_MYSQL_PASSWORD"


