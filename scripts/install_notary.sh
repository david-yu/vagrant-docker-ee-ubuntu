#!/bin/bash

sudo apt-get install -y unzip jq

export UCP_IPADDR=$(cat /vagrant/env/ucp-node1-ipaddr)
export UCP_PASSWORD=$(cat /vagrant/env/ucp_password)

# Download UCP client bundle
echo "Retrieving authtoken"
export AUTHTOKEN=$(curl -sk -N -d '{"username":"admin","password":"'"${UCP_PASSWORD}"'"}' https://${UCP_IPADDR}/auth/login | jq -r .auth_token)
sudo mkdir ucp-bundle-admin
echo "Downloading ucp bundle"
sudo -E sh -c "curl -k -H 'Authorization: Bearer ${AUTHTOKEN}' https://${UCP_IPADDR}/api/clientbundle -H 'accept: application/json, text/plain, */*' --insecure > /home/ubuntu/ucp-bundle-admin/bundle.zip"
sudo -E sh -c 'sudo unzip /home/ubuntu/ucp-bundle-admin/bundle.zip -d /home/ubuntu/ucp-bundle-admin/'
sudo rm -f /home/ubuntu/ucp-bundle-admin/bundle.zip

# Install Notary
curl -L https://github.com/docker/notary/releases/download/v0.4.3/notary-Linux-amd64 > /home/ubuntu/notary
chmod +x /home/ubuntu/notary
