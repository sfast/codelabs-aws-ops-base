#!/bin/sh

# Check if script is run as root
if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

# Here we should have basic apt update like things for various OS-s

echo "dooqod:: Wait for lock to release and update all packag lists"

apt-get -o DPkg::Lock::Timeout=-1 update -y

# apt-get -o DPkg::Lock::Timeout=-1 upgrade -y

### This is not a mistake, we need to update otherwise cant find make or gcc, or other package candidates ...

echo "dooqod:: Lock released"