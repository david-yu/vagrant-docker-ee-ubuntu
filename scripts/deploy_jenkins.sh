#!/bin/bash

export UCP_IPADDR=$(cat /vagrant/env/ucp-node1-ipaddr)
export UCP_PASSWORD=$(cat /vagrant/env/ucp_password)
export UCP_USERNAME=$(cat /vagrant/env/ucp_username)

# Get UCP Client Bundle
export AUTH_TOKEN="$(curl -sk -N -d "{\"username\":\"$UCP_USERNAME\",\"password\":\"$UCP_PASSWORD\"}" "https://${UCP_IPADDR}/auth/login" | jq -r .auth_token)"
sudo curl -k -H "Authorization: Bearer $AUTH_TOKEN" "https://${UCP_IPADDR}/api/clientbundle" -o bundle.zip
sudo mkdir bundle
sudo unzip bundle.zip -d bundle

# Set TLS Authentication Settings
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH=/home/ubuntu/bundle
export DOCKER_HOST=tcp://${UCP_IPADDR}:443

# Create Overlay Network
docker network create -d overlay jenkins

docker service create -d \
  --replicas 1 \
  --constraint 'node.hostname == jenkins-node' \
  --env DTR_URL=dtr.local \
  --env DEMO_MASTER=ucp.local \
  --env DOMAIN_NAME=local \
  --env GITHUB_USERNAME=yongshin \
  --mount type=volume,source=jenkinstest-data,destination=/var/lib/jenkins,readonly=false \
  --label com.docker.lb.hosts=jenkins.local \
  --label com.docker.lb.port=8080 \
  --network jenkins \
  --name jenkins \
  dockersolutions/jenkins:latest
