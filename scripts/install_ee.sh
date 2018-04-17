#!/bin/bash

# Add additional DNS servers to help resolve storebits.docker.com domain
sudo sh -c "echo 'nameserver 8.8.8.8
nameserver 8.8.4.4' >> /etc/resolvconf/resolv.conf.d/base"
sudo resolvconf -u

# Install Docker EE engine
export DOCKER_EE_URL=$(cat /vagrant/env/ee_url)
sudo curl -fsSL ${DOCKER_EE_URL}/ubuntu/gpg | sudo apt-key add
sudo add-apt-repository "deb [arch=amd64] ${DOCKER_EE_URL}/ubuntu $(lsb_release -cs) test-2.0"
sudo apt-get update
sudo apt-get -y install docker-ee
sudo usermod -aG docker vagrant

# Configure DNS and Graph Driver for Docker
sudo sh -c "echo '{
  \"dns\":  [\"172.17.0.1\"],
  \"storage-driver\": \"overlay2\"
}' >> /etc/docker/daemon.json"
sudo systemctl daemon-reload
sudo systemctl restart docker

# Additional step for dnsmasq on localhost
sudo apt-get -y install dnsmasq
sudo sh -c "echo 'interface=vboxnet1
listen-address=172.17.0.1' >> /etc/dnsmasq.d/docker-bridge.conf"
sudo systemctl restart dnsmasq
