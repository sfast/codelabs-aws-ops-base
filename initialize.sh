#!/bin/sh

# Check if script is run as root
if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

while getopts "u:" opt; do
  case ${opt} in
    u )
      var_username=$OPTARG
      ;;
    \? )
      echo "Usage: ops-initialize.sh [-u username]"
      exit 1
      ;;
  esac
done

# Call update.sh to update 
source ./env.sh

sh ./root/update.sh
sh ./root/install-busybox.sh
sh ./root/install-bash.sh
sh ./root/create-sudo-user.sh -u dooqod

# Run as admin user 
sudo -c "sh ./admin/install-ansible.sh"
sudo -c "sh ./admin/install-go.sh"
sudo -c "sh ./admin/install-podman.sh"

# Run as root user 
sh ./root/cleanup.sh
