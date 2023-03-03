# This script sets the Kubernetes cluster

echo "Make sure swap is disabled"
sudo swapoff -a

echo "Validating the container runtime"
sudo docker ps

