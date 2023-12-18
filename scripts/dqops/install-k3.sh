#!/bin/sh 

curl -sfL https://get.k3s.io | sh -

chown -R $USER:$(id -g -n) /etc/rancher/k3s