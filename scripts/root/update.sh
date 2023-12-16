#!/bin/sh

# Check if script is run as root
if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

# Here we should have basic apt update like things for various OS-s

echo "dooqod:: Wait for lock to release and update all packag lists"

apt-get -o DPkg::Lock::Timeout=-1 update -y

echo "dooqod:: Lock released"