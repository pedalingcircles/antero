# This script sets Helm

echo "Update apt package index"
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes

echo "Install packages to use Helm apt repo"
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

echo "Install Helm"
sudo apt-get update
sudo apt-get install helm

echo "Verify Helm installation"
helm version
