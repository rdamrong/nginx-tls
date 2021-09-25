#!/bin/bash

rm -f *.key *.crt *.csr

openssl genrsa -out ca.key 2048
openssl req -new -key ca.key -subj "/CN=My CA" -out ca.csr
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt

rm -f server*

openssl genrsa -out server1.key 2048
openssl req -new -key server1.key -subj "/CN=server1" -out server1.csr
echo subjectAltName = DNS:$(hostname),IP:$(ip a show dev enp1s0 |grep "inet "|awk '{print $2}'|cut -d "/" -f 1),IP:127.0.0.1 >> server1.cnf
echo extendedKeyUsage = serverAuth >> server1.cnf
openssl x509 -req -in server1.csr -CAkey ca.key -CA ca.crt -out server1.crt -CAcreateserial -extfile server1.cnf



time openssl dhparam -out dhparam 2048
