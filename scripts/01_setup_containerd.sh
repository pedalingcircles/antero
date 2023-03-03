# This script sets up containerd on the host machine.

# Reference documentation
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd
# https://github.com/containerd/containerd/blob/main/docs/getting-started.md
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
#
# Tip: Run this via ssh with the following command:
# ssh username@host 'echo "rootpass" | sudo -Sv && bash -s' < 01_setup_containerd.sh
# ssh -t micjohns@192.168.73.171 'bash -s' < 01_setup_containerd.sh
# ssh micjohns@192.168.73.171 'sudo bash -s' < 01_setup_containerd.sh
# ssh -t micjohns@192.168.73.171 'sudo bash -s' < 01_setup_containerd.sh

# Disable swap
echo "Disabling swap"
swapoff -a

# Setup containerd
echo "Setting up containerd"

# From https://docs.docker.com/engine/install/ubuntu/
echo "Uninstall old versions"
sudo apt-get remove docker docker-engine docker.io containerd runc

echo "Setup the repository"
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "Add Docker’s official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg

echo "Set up the stable repository"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Install Docker Engine and containerd"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Validate that Dcoker Engine is installed correctly by running the hello-world image"
sudo docker run hello-world

echo "Setup containerd configuration"
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml