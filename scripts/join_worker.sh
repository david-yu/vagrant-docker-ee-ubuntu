export UCP_IPADDR=$(cat /vagrant/ucp-node1-ipaddr)
export SWARM_JOIN_TOKEN_WORKER=$(cat /vagrant/swarm-join-token-worker)
docker swarm join --token ${SWARM_JOIN_TOKEN_WORKER} ${UCP_IPADDR}:2377
