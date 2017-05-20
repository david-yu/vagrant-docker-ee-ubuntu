export UCP_IPADDR=$(cat /vagrant/ucp-node1-ipaddr)
export UCP_PASSWORD=$(cat /vagrant/ucp_password)
export HUB_USERNAME=$(cat /vagrant/hub_username)
export HUB_PASSWORD=$(cat /vagrant/hub_password)
docker run --rm --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.1.3 install --host-address ${UCP_IPADDR} --admin-password ${UCP_PASSWORD} --san ucp.local --license $(cat /vagrant/docker_subscription.lic)
docker swarm join-token manager | awk -F " " '/token/ {print $2}' > /vagrant/swarm-join-token-mgr
docker swarm join-token worker | awk -F " " '/token/ {print $2}' > /vagrant/swarm-join-token-worker
docker run --rm --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.1.3 id | awk '{ print $1}' > /vagrant/ucp-vancouver-id
export UCP_ID=$(cat /vagrant/ucp-vancouver-id)
docker run --rm -i --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.1.3 backup --id ${UCP_ID} --root-ca-only --passphrase "secret" > /vagrant/backup.tar
