# HRM Deployment
docker service create \
  --network ucp-hrm \
  --name=viz \
  --publish=8080 \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  --label com.docker.ucp.mesh.http.8080=external_route=http://visualizer.local,internal_port=8080 \
  dockersamples/visualizer

# Non-HRM Deployment
docker service create \
  --name=viz \
  --publish=8080:8080/tcp \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  dockersamples/visualizer
