#!/bin/sh

# busybox has which

if [[ "$(uname -s)" == "Linux" ]]; then
    if [[ -f /etc/redhat-release ]]; then
        # CentOS/RHEL
        which ansible || (dnf install -y epel-release && dnf install -y ansible)
    elif [[ -f /etc/debian_version ]]; then
        # Debian/Ubuntu
        which ansible || apt-get install -y ansible
    elif [[ -f /etc/alpine-release ]]; then
        # Alpine
        which ansible || apk add ansible --no-progress
    elif [[ -f /etc/os-release ]] && [[ "$(cat /etc/os-release | grep ^ID= | cut -d= -f2)" == "amazon-linux-2" ]]; then
        # Amazon Linux 2
        which ansible || amazon-linux-extras install ansible2
    elif [[ -f /etc/os-release ]] && [[ "$(cat /etc/os-release | grep ^ID= | cut -d= -f2)" == "arch" ]]; then
        # Arch Linux
        which ansible || pacman -S ansible --noconfirm
    fi
fi
