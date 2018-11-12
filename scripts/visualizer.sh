#!/bin/bash

set -e

docker network create -d overlay visualizer

docker service create -d \
  --replicas 1 \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  --label com.docker.lb.hosts=visualizer.local \
  --label com.docker.lb.port=8080 \
  --label node.labels.com.docker.ucp.orchestrator.swarm==true \
  --network visualizer \
  --name visualizer \
  dockersamples/visualizer
