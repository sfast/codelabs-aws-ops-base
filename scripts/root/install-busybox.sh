#!/bin/sh

# Check if script is run as root
if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

if [[ "$(uname -s)" == "Linux" ]]; then
    if [[ -f /etc/redhat-release ]]; then
        # CentOS/RHEL
        # TODO
    elif [[ -f /etc/debian_version ]]; then
        # Debian/Ubuntu

        # busybox modinfo has no -k option
        apt-get install -y kmod
        # install busybox
        apt-get install -y busybox
        sh -c 'for i in $(busybox --list); do ln -s /usr/bin/busybox /usr/bin/$i; done'
       
    elif [[ -f /etc/alpine-release ]]; then
        # Alpine
        # TODO
    elif [[ -f /etc/os-release ]] && [[ "$(cat /etc/os-release | grep ^ID= | cut -d= -f2)" == "amazon-linux-2" ]]; then
        # Amazon Linux 2
        # TODO
    fi
fi
