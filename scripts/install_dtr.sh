#!/bin/bash

< /dev/urandom tr -dc a-f0-9 | head -c${1:-12} > /vagrant/dtr-replica-id
ifconfig enp0s8 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' > /vagrant/dtr-node1-ipaddr
export UCP_IPADDR=$(cat /vagrant/ucp-node1-ipaddr)
export UCP_PASSWORD=$(cat /vagrant/ucp_password)
export DTR_REPLICA_ID=$(cat /vagrant/dtr-replica-id)
export DTR_VERSION=2.3.0

sudo -E sh -c 'curl -k https://${UCP_IPADDR}/ca > /home/ubuntu/ucp-ca.pem'

# Sleep 35 seconds to wait for node registration
sleep 35

# Install DTR
sudo -E sh -c 'docker run --rm docker/dtr:${DTR_VERSION} install --ucp-url https://"${UCP_IPADDR}" --ucp-node dtr-node1 --replica-id "${DTR_REPLICA_ID}" --dtr-external-url https://dtr.local --ucp-username admin --ucp-password "${UCP_PASSWORD}" --ucp-ca "$(cat ucp-ca.pem)"'
# Run backup of DTR
sudo -E sh -c 'docker run --rm docker/dtr:${DTR_VERSION} backup --ucp-url https://${UCP_IPADDR} --existing-replica-id ${DTR_REPLICA_ID} --ucp-username admin --ucp-password ${UCP_PASSWORD} --ucp-ca "$(cat ucp-ca.pem)" > /tmp/backup.tar'

# Trust self-signed DTR CA
sudo sh -c 'curl -k https://dtr.local/ca -o /usr/local/share/ca-certificates/dtr.local.crt'
sudo update-ca-certificates
sudo systemctl restart docker
