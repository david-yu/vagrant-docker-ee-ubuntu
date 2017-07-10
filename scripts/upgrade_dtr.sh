#!/bin/bash

export DTR_VERSION=2.2.5
export UCP_IPADDR=$(cat /vagrant/ucp-vancouver-node1-ipaddr)
export UCP_PASSWORD=$(cat /vagrant/ucp_password)
export DTR_REPLICA_ID=$(cat /vagrant/dtr-replica-id)

docker pull docker/dtr:${DTR_VERSION}

docker run -it --rm \
  docker/dtr:${DTR_VERSION} upgrade --ucp-url https://${UCP_IPADDR} \
  --ucp-username admin --ucp-password ${UCP_PASSWORD} --existing-replica-id ${DTR_REPLICA_ID} \
  --ucp-insecure-tls
