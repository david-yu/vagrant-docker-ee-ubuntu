#!/bin/bash
export UCP_VERSION=2.2.3

ifconfig enp0s8 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' > /vagrant/ucp-node1-ipaddr
export UCP_IPADDR=$(cat /vagrant/ucp-node1-ipaddr)
export UCP_PASSWORD=$(cat /vagrant/ucp_password)
export UCP_USERNAME=$(cat /vagrant/ucp_username)
docker run --rm --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:${UCP_VERSION} install --host-address ${UCP_IPADDR} --admin-username ${UCP_USERNAME} --admin-password ${UCP_PASSWORD} --san ucp.local --license $(cat /vagrant/docker_subscription.lic)
docker swarm join-token manager | awk -F " " '/token/ {print $2}' > /vagrant/swarm-join-token-mgr
docker swarm join-token worker | awk -F " " '/token/ {print $2}' > /vagrant/swarm-join-token-worker
docker run --rm --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:${UCP_VERSION} id | awk '{ print $1}' > /vagrant/ucp-id
export UCP_ID=$(cat /vagrant/ucp-id)
docker run --rm -i --log-driver none --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:${UCP_VERSION} backup --id ${UCP_ID} --root-ca-only --passphrase "secret" > /vagrant/backup.tar
# Enable HRM
export AUTH_TOKEN="$(curl -sk -d '{"username":"admin","password":"${UCP_PASSWORD"}' "https://${UCP_IPADDR}/auth/login" | jq -r .auth_token 2>/dev/null)"
curl -sk -X POST -H "Authorization: Bearer ${AUTH_TOKEN}" --header "Content-Type: application/json" --header "Accept: application/json" -d '{"HTTPPort":80,"HTTPSPort":8443}' "https://${UCP_IPADDR}/api/hrm"
