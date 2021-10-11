#!/bin/bash

rm -f *.key *.crt *.csr

openssl ecparam -out ca.key -name prime256v1 -genkey
openssl req -new -x509  -key ca.key -out ca.crt  -subj "/CN=My CA EC" 
rm -f server*

openssl ecparam -out server1.key -name prime256v1 -genkey
openssl req -new -key server1.key -out server1.csr -sha256 -subj "/CN=server1"
echo subjectAltName = DNS:$(hostname),IP:$(ip a show dev eth0 |grep "inet "|awk '{print $2}'|cut -d "/" -f 1),IP:127.0.0.1 >> server1.cnf
echo extendedKeyUsage = serverAuth >> server1.cnf
openssl x509 -req -in server1.csr -CAkey ca.key -CA ca.crt -out server1.crt -CAcreateserial -extfile server1.cnf

time openssl dhparam -out dhparam 2048
