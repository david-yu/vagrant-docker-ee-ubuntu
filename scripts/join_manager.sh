#!/bin/bash

export UCP_IPADDR=$(cat /vagrant/env/ucp-node1-ipaddr)
export SWARM_JOIN_TOKEN_MASTER=$(cat /vagrant/env/swarm-join-token-mgr)
docker swarm join --token ${SWARM_JOIN_TOKEN_MASTER} ${UCP_IPADDR}:2377
