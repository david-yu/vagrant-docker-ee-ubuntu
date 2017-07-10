docker service create \
  --network ucp-hrm \
  --publish 444:443 --publish 8088:80 --publish 2022:22 \
  --hostname gitlab.local \
  --name gitlab \
  --label com.docker.ucp.mesh.http.8088=external_route=http://gitlab.local,internal_port=8088 \
  --mount type=bind,source=/srv/gitlab/config,destination=/etc/gitlab \
  --mount type=bind,source=/srv/gitlab/logs,destination=/var/log/gitlab \
  --mount type=bind,source=/srv/gitlab/data,destination=/var/opt/gitlab \
  --constraint 'node.labels.gitlab == master' \
  gitlab/gitlab-ce:latest
