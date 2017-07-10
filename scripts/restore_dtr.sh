#!/bin/bash

export UCP_IPADDR=$(cat /vagrant/ucp-node1-ipaddr)
export DTR_IPADDR=$(cat /vagrant/dtr-node1-ipaddr)
export UCP_PASSWORD=$(cat /vagrant/ucp_password)

curl -k https://${UCP_IPADDR}/ca > ucp-ca.pem
docker run --rm --it docker/dtr:2.2.5 destroy --ucp-insecure-tls
docker run --rm docker/dtr:2.2.5 restore --ucp-url ${UCP-IPADDR} --ucp-username admin \
  --ucp-password dockeradmin --dtr-external-url https://dtr.local --ucp-node dtr-node1 \
  --ucp-ca "$(cat ucp-ca.pem)"  < /tmp/backup.tar
