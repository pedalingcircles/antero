# This script sets up containerd on the host machine.

# Reference documentation
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd
# https://github.com/containerd/containerd/blob/main/docs/getting-started.md
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
#
# Tip: Run this via ssh with the following command (must allow root login):
# ssh root@192.168.73.171 'bash -s' < 01_setup_containerd.sh

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

echo "Set the cgroup driver for containerd to systemd which is required for the kubelet."
sudo sed -i 's/            SystemdCgroup = false/            SystemdCgroup = true/' /etc/containerd/config.toml

echo "Restart containerd with new settings"
sudo systemctl restart containerd

# Forwarding IPv4 and letting iptables see bridged traffic
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Verify that the br_netfilter, overlay modules are loaded
lsmod | grep br_netfilter
lsmod | grep overlay

# Verify that the net.bridge.bridge-nf-call-iptables, net.bridge.bridge-nf-call-ip6tables, net.ipv4.ip_forward system variables are set to 1 in your sysctl
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

# Check the status of our container runtime, containerd.
# will enter a crashloop until a cluster is created or the node is joined to an existing cluster.
sudo systemctl status containerd.service 

#Ensure set to start when the system starts up.
sudo systemctl enable containerd.service