#!/bin/bash

set -e

export UCP_IPADDR=$(cat /vagrant/env/ucp-node1-ipaddr)
export DTR_IPADDR=$(cat /vagrant/env/dtr-node1-ipaddr)
export UCP_PASSWORD=$(cat /vagrant/env/ucp_password)
export DTR_REPLICA_ID=$(cat /vagrant/env/dtr-replica-id)
export DTR_FQDN=dtr.local
export DTR_VERSION=2.5.0

docker run --rm -it docker/dtr:${DTR_VERSION} destroy \
  --replica-id ${DTR_REPLICA_ID} --ucp-url ${UCP_IPADDR} --ucp-username docker \
  --ucp-password dockeradmin --ucp-insecure-tls

cp /vagrant/dtr_backup.tar .

docker run --rm -i docker/dtr:${DTR_VERSION} restore --ucp-url ${UCP_IPADDR} --ucp-username docker \
  --ucp-password dockeradmin --dtr-external-url ${DTR_FQDN} --ucp-node dtr \
  --replica-id ${DTR_REPLICA_ID} --ucp-insecure-tls  < dtr_backup.tar
