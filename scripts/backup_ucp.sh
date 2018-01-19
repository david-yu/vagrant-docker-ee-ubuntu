#!/bin/bash

export UCP_ID=$(cat /vagrant/env/ucp-id)
export UCP_VERSION=3.0.0-beta2

# Run Backup
docker run --rm -i --log-driver none --name \
  ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:${UCP_VERSION} backup \
  --id ${UCP_ID} --root-ca-only --passphrase "secret" > /vagrant/backup_ucp.tar
