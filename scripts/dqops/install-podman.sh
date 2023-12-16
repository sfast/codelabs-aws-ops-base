#!/bin/sh

# You can always check which version will be installed with 
# sudo apt-cache policy podman

# You will get something like this. You can see that 4.3 is latest available verison. 

# podman:
#   Installed: (none)
#   Candidate: 4.3.1+ds1-8+b1
#   Version table:
#      4.3.1+ds1-8+b1 500
#         500 mirror+file:/etc/apt/mirrors/debian.list bookworm/main amd64 Packages


# We want to install version 4.8 from https://github.com/containers/podman

git clone -b v4.8 https://github.com/containers/podman.git

cd ./podman

# We need also go to be installed version 1.20

apt-get install -y \
  make \
  gcc \
  git \
  btrfs-progs \
  go-md2man \
  crun \
  git \
  iptables \
  libassuan-dev \
  libbtrfs-dev \
  libc6-dev \
  libdevmapper-dev \
  libglib2.0-dev \
  libgpgme-dev \
  libgpg-error-dev \
  libprotobuf-dev \
  libprotobuf-c-dev \
  libseccomp-dev \
  libselinux1-dev \
  libsystemd-dev \
  libapparmor-dev \
  netavark \
  pkg-config \
  conmon \
  uidmap \
  slirp4netns \
  newuidmap \

### Add configuration 

mkdir -p /etc/containers
curl -L -o /etc/containers/registries.conf https://src.fedoraproject.org/rpms/containers-common/raw/main/f/registries.conf
curl -L -o /etc/containers/policy.json https://src.fedoraproject.org/rpms/containers-common/raw/main/f/default-policy.json


# The command sudo sysctl kernel.unprivileged_userns_clone=1 is used to enable unprivileged user namespaces in the Linux kernel. 
# This setting is often necessary for running containers using tools like Podman and Docker, especially when running them as a non-root user.
# enable 
sysctl kernel.unprivileged_userns_clone=1
# enable permanently
sh -c 'echo 'kernel.unprivileged_userns_clone=1' >> /etc/sysctl.d/userns.conf'
sh -c 'echo 'kernel.unprivileged_userns_clone=1' >> /etc/sysctl.conf'

sh -c 'sysctl --system'

sudo apt-get install -y dbus-user-session
sudo apt-get install -y fuse-overlayfs



make BUILDTAGS="exclude_graphdriver_devicemapper selinux seccomp systemd" PREFIX=/usr
make install PREFIX=/usr


# Clean the podman repo

cd ..
rm -rf podman

echo "Run - podman info"

# Some warning we get after this , but maybe not as crucial, we will fix later 
# lets try podman to run alpine 

# WARN[0000] The cgroupv2 manager is set to systemd but there is no systemd user session available 
# WARN[0000] For using systemd, you may need to log in using a user session 
# WARN[0000] Alternatively, you can enable lingering with: `loginctl enable-linger 1000` (possibly as root) 
# WARN[0000] Falling back to --cgroup-manager=cgroupfs    
# WARN[0000] The cgroupv2 manager is set to systemd but there is no systemd user session available 
# WARN[0000] For using systemd, you may need to log in using a user session 
# WARN[0000] Alternatively, you can enable lingering with: `loginctl enable-linger 1000` (possibly as root) 
# WARN[0000] Falling back to --cgroup-manager=cgroupfs 
