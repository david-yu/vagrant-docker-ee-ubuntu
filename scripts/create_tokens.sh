docker swarm join-token manager | awk -F " " '/token/ {print $2}' > /vagrant/swarm-join-token-mgr
docker swarm join-token worker | awk -F " " '/token/ {print $2}' > /vagrant/swarm-join-token-worker
