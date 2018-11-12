set -e

docker swarm join-token -q manager > /vagrant/env/swarm-join-token-mgr
docker swarm join-token -q worker > /vagrant/env/swarm-join-token-worker
