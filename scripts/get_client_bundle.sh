#!/bin/bash

set -e

export UCP_IPADDR=$(cat /vagrant/env/ucp-node1-ipaddr)
export UCP_PASSWORD=$(cat /vagrant/env/ucp_password)
export UCP_USERNAME=$(cat /vagrant/env/ucp_username)

# Get UCP Client Bundle
export AUTH_TOKEN="$(curl -sk -N -d "{\"username\":\"$UCP_USERNAME\",\"password\":\"$UCP_PASSWORD\"}" "https://${UCP_IPADDR}/auth/login" | jq -r .auth_token)"
sudo curl -k -H "Authorization: Bearer $AUTH_TOKEN" "https://${UCP_IPADDR}/api/clientbundle" -o bundle.zip
sudo mkdir bundle
sudo unzip bundle.zip -d bundle
