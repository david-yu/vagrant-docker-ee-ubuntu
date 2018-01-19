#!/bin/bash

export UCP_IPADDR=$(cat /vagrant/env/ucp-node1-ipaddr)
export DTR_IPADDR=$(cat /vagrant/env/dtr-node1-ipaddr)
export UCP_PASSWORD=$(cat /vagrant/env/ucp_password)
export DTR_VERSION=2.5.0-beta2

docker run --rm -it docker/dtr:${DTR_VERSION} destroy \
  --ucp-url ${UCP-IPADDR} --ucp-username docker \
  --ucp-password dockeradmin --ucp-insecure-tls

docker run --rm docker/dtr:${DTR_VERSION}restore --ucp-url ${UCP-IPADDR} --ucp-username docker \
  --ucp-password dockeradmin --dtr-external-url https://dtr.local --ucp-node dtr-node1 \
  --ucp-insecure-tls  < /vagrant/backup.tar
