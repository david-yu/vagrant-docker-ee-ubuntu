#!/bin/bash

< /dev/urandom tr -dc a-f0-9 | head -c${1:-12} > /vagrant/env/dtr-replica-id
ifconfig enp0s8 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' > /vagrant/env/dtr-node1-ipaddr
export UCP_IPADDR=$(cat /vagrant/env/ucp-node1-ipaddr)
export UCP_USERNAME=$(cat /vagrant/env/ucp_username)
export UCP_PASSWORD=$(cat /vagrant/env/ucp_password)
export DTR_REPLICA_ID=$(cat /vagrant/env/dtr-replica-id)
export DTR_VERSION=2.5.0

# Sleep 90 seconds to wait for node registration and for swarm node to come up healthy
sleep 90

# Install DTR
sudo -E sh -c 'docker run --rm docker/dtr:${DTR_VERSION} install --ucp-url https://"${UCP_IPADDR}" --ucp-node dtr --replica-id "${DTR_REPLICA_ID}" --dtr-external-url https://dtr.local --ucp-username "${UCP_USERNAME}" --ucp-password "${UCP_PASSWORD}" --ucp-insecure-tls'
# Run backup of DTR
sudo -E sh -c 'docker run --rm --log-driver none docker/dtr:${DTR_VERSION} backup --ucp-url https://"${UCP_IPADDR}" --existing-replica-id "${DTR_REPLICA_ID}" --ucp-username "${UCP_USERNAME}" --ucp-password "${UCP_PASSWORD}" --ucp-insecure-tls > /tmp/backup.tar'

# Sleep 30 seconds to wait for DTR to come back up
sleep 30
