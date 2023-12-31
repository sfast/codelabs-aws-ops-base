#!/bin/sh

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

# while getopts "u:" opt; do
#   case ${opt} in
#     u )
#       var_username=$OPTARG
#       ;;
#     \? )
#       echo "Usage: ops-initialize.sh [-u username]"
#       exit 1
#       ;;
#   esac
# done

## Install git, clone and run the rest, this can be an S# script actually...
# apt-get install -y git
# git clone -b develop https://github.com/sfast/codelabs-aws-ops-base
# cd ./codelabs-aws-ops-base

SCRIPT_ROOT=$(pwd)
OPS_BASE_USER="dqops"

sh $SCRIPT_ROOT/scripts/root/update.sh
sh $SCRIPT_ROOT/scripts/root/install-bash.sh
sh $SCRIPT_ROOT/scripts/root/install-busybox.sh
sh $SCRIPT_ROOT/scripts/root/create-sudo-user.sh -u "$OPS_BASE_USER"

# Source env.sh 
source ./env.sh

# Run as admin user 
su - "$OPS_BASE_USER" <<EOF

sudo sh $SCRIPT_ROOT/scripts/dqops/install-ansible.sh
sudo sh $SCRIPT_ROOT/scripts/dqops/install-go.sh
sudo sh $SCRIPT_ROOT/scripts/dqops/install-podman.sh
sudo sh $SCRIPT_ROOT/scripts/dqops/install-k3.sh

EOF

# Run as root user 
sh $SCRIPT_ROOT/scripts/root/cleanup.sh
