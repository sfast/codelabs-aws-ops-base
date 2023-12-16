#!/bin/sh

apt-get install -y gpg make gcc ca-certificates curl gnupg

curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

apt-get -o DPkg::Lock::Timeout=-1 update -y

# curl -fsSL https://get.docker.com -o get-docker.sh
# sudo chmod +x get-docker.sh
# sudo sh get-docker.sh

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose

usermod -aG docker $USER

echo "Note: admin user is added under docker group so you dont need sudo to run docker commands"
echo "Exit session or open new terminal and run - 'docker info' "
