#
# Install dependencies
#
apt install -y htop vim git sshpass ansible curl wget 


useradd -m kube
passwd kube
sudo usermod -aG sudo kube
echo "kube ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/kube



#
# Setup NFS
#
apt install -y nfs-common
mkdir /mnt/market_place
echo "10.1.1.202:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
mkdir /mnt/kubernetes
echo "10.1.1.202:/volume1/kubernetes /mnt/kubernetes nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab


#
# Install docker
#
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg


echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
groupadd docker
gpasswd -a root docker
gpasswd -a cluster docker


curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

#
# Install kubernetes
#
#apt install -y gnupg2
#apt -y install curl apt-transport-https
#curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
#echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
#apt update
#apt -y install kubelet kubeadm kubectl
#apt-mark hold kubelet kubeadm kubectl


#
# Machines fixs
#
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
reboot now

