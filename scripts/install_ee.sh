# Install Docker EE engine
export DOCKER_EE_URL=$(cat /vagrant/ee_url)
sudo curl -fsSL ${DOCKER_EE_URL}/gpg | sudo apt-key add
sudo add-apt-repository "deb [arch=amd64] ${DOCKER_EE_URL} $(lsb_release -cs) stable-17.03"
sudo apt-get update
sudo apt-get -y install docker-ee
sudo usermod -aG docker ubuntu
ifconfig enp0s8 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' > /vagrant/ucp-node1-ipaddr

# Configure dns for Docker
sudo sh -c "echo '{
  \"dns\":  [\"172.17.0.1\"]
}' >> /etc/docker/daemon.json"
sudo systemctl daemon-reload
sudo systemctl start docker

# Additional step for dnsmasq on localhost
sudo sh -c "echo 'interface=vboxnet1
listen-address=172.17.0.1' >> /etc/dnsmasq.d/docker-bridge.conf"
sudo systemctl start dnsmasq
