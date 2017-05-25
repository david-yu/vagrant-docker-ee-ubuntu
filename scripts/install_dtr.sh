< /dev/urandom tr -dc a-f0-9 | head -c${1:-12} > /vagrant/dtr-replica-id
ifconfig enp0s8 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' > /vagrant/dtr-node1-ipaddr
export UCP_IPADDR=$(cat /vagrant/ucp-node1-ipaddr)
export UCP_PASSWORD=$(cat /vagrant/ucp_password)
export DTR_REPLICA_ID=$(cat /vagrant/dtr-replica-id)

# Join Swarm
export SWARM_JOIN_TOKEN_WORKER=$(cat /vagrant/swarm-join-token-worker)
docker swarm join --token ${SWARM_JOIN_TOKEN_WORKER} ${UCP_IPADDR}:2377

# Install DTR
sudo curl -k https://${UCP_IPADDR}/ca > ucp-ca.pem
docker run --rm docker/dtr:2.2.4 install --ucp-url https://${UCP_IPADDR} --ucp-node dtr-node1 --replica-id ${DTR_REPLICA_ID} --dtr-external-url https://dtr.local --ucp-username admin --ucp-password ${UCP_PASSWORD} --ucp-ca "$(cat ucp-ca.pem)"
# Run backup of DTR
docker run --rm docker/dtr:2.2.4 backup --ucp-url https://${UCP_IPADDR} --existing-replica-id ${DTR_REPLICA_ID} --ucp-username admin --ucp-password ${UCP_PASSWORD} --ucp-ca "$(cat ucp-ca.pem)" > /tmp/backup.tar

# Trust self-signed DTR CA
sudo curl -k https://dtr.local/ca -o /etc/pki/ca-trust/source/anchors/dtr.local.crt
sudo update-ca-certificates
sudo service docker restart
