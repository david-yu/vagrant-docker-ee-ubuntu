#!/bin/bash

# Install Docker EE engine
sudo dpkg -i /vagrant/package/docker-ee*
sudo apt-get -y install -f
sudo usermod -aG docker ubuntu

# Configure dns for Docker
sudo sh -c "echo '{
  \"dns\":  [\"172.17.0.1\"]
}' >> /etc/docker/daemon.json"
sudo systemctl daemon-reload
sudo systemctl restart docker

# Additional step for dnsmasq on localhost
sudo apt-get -y install dnsmasq
sudo sh -c "echo 'interface=vboxnet1
listen-address=172.17.0.1' >> /etc/dnsmasq.d/docker-bridge.conf"
sudo systemctl restart dnsmasq
