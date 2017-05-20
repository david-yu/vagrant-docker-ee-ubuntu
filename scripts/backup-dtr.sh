export UCP_PASSWORD=$(cat /vagrant/ucp_password)
export UCP_IPADDR=$(cat /vagrant/ucp-vancouver-node1-ipaddr)
export DTR_IPADDR=$(cat /vagrant/dtr-vancouver-node1-ipaddr)
export SWARM_JOIN_TOKEN_WORKER=$(cat /vagrant/swarm-join-token-worker)
export DTR_REPLICA_ID=$(cat /vagrant/dtr-replica-id)

docker run --rm docker/dtr:2.2.4 backup --ucp-url https://${UCP_IPADDR} --existing-replica-id ${DTR_REPLICA_ID} --ucp-username admin --ucp-password ${UCP_PASSWORD} --ucp-ca "$(cat ucp-ca.pem)" > /tmp/backup.tar
