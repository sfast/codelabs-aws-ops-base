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


SCRIPT_ROOT=$(pwd)
$OPS_BASE_USER="dqops"

# Call update.sh to update 
source ./env.sh

sh $SCRIPT_ROOT/scripts/root/update.sh
sh $SCRIPT_ROOT/scripts/root/install-busybox.sh
sh $SCRIPT_ROOT/scripts/root/install-bash.sh
sh $SCRIPT_ROOT/scripts/root/create-sudo-user.sh -u "$OPS_BASE_USER"

# Run as admin user 
su - "$OPS_BASE_USER" <<EOF

sudo sh $SCRIPT_ROOT/scripts/admin/install-ansible.sh
sudo sh $SCRIPT_ROOT/scripts/admin/install-go.sh
sudo sh $SCRIPT_ROOT/scripts/admin/install-podman.sh

EOF

# Run as root user 
sh $SCRIPT_ROOT/scripts/root/cleanup.sh
