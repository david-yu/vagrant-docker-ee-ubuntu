#!/bin/bash

set -e

export UCP_ID=$(cat /vagrant/env/ucp-id)
export UCP_VERSION=3.1.0

# Run Backup
docker run --rm -i --log-driver none --name \
  ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:${UCP_VERSION} backup \
  --id ${UCP_ID} --root-ca-only --passphrase "dockeradmin123" > /vagrant/backup_ucp.tar

# Wait for UCP to revive
sleep 15
