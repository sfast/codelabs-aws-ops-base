#!/bin/sh

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

apt-get install -y bash
