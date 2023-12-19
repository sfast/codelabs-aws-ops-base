#!/bin/sh

# Debian/Ubuntu

# busybox modinfo has no -k option
apt-get install -y kmod
# install busybox
apt-get install -y busybox
sh -c 'for i in $(busybox --list); do ln -s /usr/bin/busybox /usr/bin/$i; done'