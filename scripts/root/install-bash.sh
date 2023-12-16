#!/bin/sh

# Check if script is run as root
if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

if [[ "$(uname -s)" == "Linux" ]]; then
    if [[ -f /etc/redhat-release ]]; then
        # CentOS/RHEL
        which bash || dnf install -y bash
    elif [[ -f /etc/debian_version ]]; then
        # Debian/Ubuntu
        which bash || apt-get install -y bash
    elif [[ -f /etc/alpine-release ]]; then
        # Alpine
        which bash || apk add bash --no-progress
    elif [[ -f /etc/os-release ]] && [[ "$(cat /etc/os-release | grep ^ID= | cut -d= -f2)" == "amazon-linux-2" ]]; then
        # Amazon Linux 2
         which bash || amazon-linux-extras install bash2
    fi
fi
