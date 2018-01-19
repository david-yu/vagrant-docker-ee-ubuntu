#!/bin/bash

export UCP_PASSWORD=$(cat /vagrant/env/ucp_password)
export UCP_IPADDR=$(cat /vagrant/env/ucp-node1-ipaddr)
export DTR_IPADDR=$(cat /vagrant/env/dtr-node1-ipaddr)
export DTR_REPLICA_ID=$(cat /vagrant/env/dtr-replica-id)
export DTR_VERSION=2.5.0-beta3

docker run --rm docker/dtr:${DTR_VERSION} backup --ucp-url https://${UCP_IPADDR} --existing-replica-id ${DTR_REPLICA_ID} --ucp-username docker --ucp-password ${UCP_PASSWORD} --ucp-insecure-tls > /vagrant/dtr_backup.tar
