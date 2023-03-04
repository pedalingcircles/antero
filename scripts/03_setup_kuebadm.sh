# This script sets the Kubernetes cluster

echo "Make sure swap is disabled"
sudo swapoff -a

echo "Validating the container runtime"
sudo docker ps

# Install kubeadm
echo "Update apt package index"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

echo "Download Google Cloud public signing key"
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "Add the Kubernetes apt repository"
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Add the apt package index, install kubeadm, and kubectl and pin versions"
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Check the status of our kubelet
# The kubelet will enter a crashloop until a cluster is created or the node is joined to an existing cluster.
sudo systemctl status kubelet.service 

# Ensure to start when the system starts up.
sudo systemctl enable kubelet.service

# Verify 
kubectl version --short