#!/bin/sh


docker container stop nginx
docker container rm nginx


docker container run -d --rm --name nginx \
       -p 80:80 -p 443:443 \
       -v $(pwd)/config/ssl.conf:/etc/nginx/conf.d/ssl.conf \
       -v $(pwd)/config/server1.crt:/etc/nginx/conf.d/server1.crt \
       -v $(pwd)/config/server1.key:/etc/nginx/conf.d/server1.key \
       -v $(pwd)/config/dhparam:/etc/nginx/conf.d/dhparam \
       nginx:alpine


echo "#############################"

docker container ls -l
