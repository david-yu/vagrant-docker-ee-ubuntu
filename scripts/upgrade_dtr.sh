#!/bin/bash

export DTR_VERSION=2.3.3
export UCP_IPADDR=$(cat /vagrant/env/ucp-vancouver-node1-ipaddr)
export UCP_PASSWORD=$(cat /vagrant/env/ucp_password)
export DTR_REPLICA_ID=$(cat /vagrant/env/dtr-replica-id)

docker pull docker/dtr:${DTR_VERSION}

docker run -it --rm \
  docker/dtr:${DTR_VERSION} upgrade --ucp-url https://${UCP_IPADDR} \
  --ucp-username admin --ucp-password ${UCP_PASSWORD} \
  --ucp-insecure-tls
