#!/bin/bash

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

while getopts "u:p:" opt; do
  case ${opt} in
    u )
      var_username=$OPTARG
      ;;
    p )
      var_password=$OPTARG
      ;;
    \? )
      echo "Usage: ops-create-user.sh [-u username] [-p password]"
      exit 1
      ;;
  esac
done

if [[ -z "$var_username" ]]; then
  echo "Error: missing required argument"
  echo "Usage: ops-create-user.sh [-u username] [-p password]"
  exit 1
fi

# Set a default value for var_password if it is not provided
var_password=${var_password:-""}

# Check if the user already exists
if id "$var_username" >/dev/null 2>&1; then
  echo "User $var_username already exists"
else

  # Add the user to the sudoers group
  case "$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"' | tr '[:upper:]' '[:lower:]')" in
    "debian" | "ubuntu" | "kali")
      # Create the user
      apt install -y sudo
      useradd -m -s /bin/bash "$var_username"

      if [[ -n "$var_password" ]]; then
        # Set the password
        echo "$var_username:$var_password" | chpasswd -e
      fi

      usermod -aG sudo "$var_username"
      touch "/etc/sudoers.d/$var_username"
      echo "$var_username ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$var_username"
      ;;
    "centos" | "rhel" | "redhatenterpriseserver" | "amzn" | "ol" )

      yum install -y sudo shadow-utils util-linux-user
      
      useradd -m -s /bin/bash "$var_username"

      if [[ -n "$var_password" ]]; then
        # Set the password
        echo "$var_username:$var_password" | chpasswd -e
      fi

      usermod -aG wheel "$var_username"

      touch "/etc/sudoers.d/$var_username"
      
      echo "$var_username ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$var_username"
      ;;
    "alpine")
      apk add sudo shadow

      useradd -m -s /bin/bash "$var_username"

      if [[ -n "$var_password" ]]; then
        # Set the password
        echo "$var_username:$var_password" | chpasswd -e
      fi

      addgroup -S sudo

      adduser "$var_username" sudo
      
      touch "/etc/sudoers.d/$var_username"
      
      echo "$var_username ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$var_username"
      ;;
    "arch")
      pacman -Syu --noconfirm
      
      pacman -S --noconfirm sudo

      useradd -m -s /bin/bash "$var_username"

      if [[ -n "$var_password" ]]; then
        # Set the password
        echo "$var_username:$var_password" | chpasswd -e
      fi

      usermod -aG wheel "$var_username"
      
      touch "/etc/sudoers.d/$var_username"

      echo "$var_username ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$var_username"
      
      chmod 440 "/etc/sudoers.d/$var_username"
      ;;
    *)
      echo "Unsupported Linux distribution"
      exit 1
      ;;
  esac

  mkdir -p /etc/sudoers.d

  # Set the correct permissions for the sudoers file
  chmod 0440 "/etc/sudoers.d/$var_username"
  chown -R $var_username /home/$var_username

  # Check if enabled loginctl show-user $USER -p Linger
  # linger is a way to ensure systemd services are runnig after user log out ....
  loginctl enable-linger $USER

fi

