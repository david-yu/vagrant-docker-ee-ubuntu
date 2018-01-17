#!/bin/bash
export UCP_VERSION=3.0.0-beta2

ifconfig enp0s8 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' > /vagrant/env/ucp-node1-ipaddr
export UCP_IPADDR=$(cat /vagrant/env/ucp-node1-ipaddr)
export UCP_USERNAME=$(cat /vagrant/env/ucp_username)

if [ ! -f /vagrant/files/ucp_password ]; then
  echo 'dockeradmin' > /vagrant/env/ucp_password
fi
export UCP_PASSWORD=$(cat /vagrant/env/ucp_password)

# Install UCP
if [[ $(cat /vagrant/files/docker_subscription.lic) ]]; then
  docker run --rm --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:${UCP_VERSION} install --force-minimums --host-address ${UCP_IPADDR} --admin-username ${UCP_USERNAME} --admin-password ${UCP_PASSWORD} --san ucp.local --license $(cat /vagrant/files/docker_subscription.lic)
else
  docker run --rm --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:${UCP_VERSION} install --force-minimums --host-address ${UCP_IPADDR} --admin-username ${UCP_USERNAME} --admin-password ${UCP_PASSWORD} --san ucp.local
fi

# Gather Swarm Tokens and UCP cluster id
docker swarm join-token manager | awk -F " " '/token/ {print $2}' > /vagrant/env/swarm-join-token-mgr
docker swarm join-token worker | awk -F " " '/token/ {print $2}' > /vagrant/env/swarm-join-token-worker
docker run --rm --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:${UCP_VERSION} id | awk '{ print $1}' > /vagrant/env/ucp-id
export UCP_ID=$(cat /vagrant/env/ucp-id)

# Enable HRM
export AUTH_TOKEN="$(curl -sk -d "{\"username\":\"$UCP_USERNAME\",\"password\":\"$UCP_PASSWORD\"}" "https://${UCP_IPADDR}/auth/login" | jq -r .auth_token 2>/dev/null)"
curl -sk -X POST -H "Authorization: Bearer ${AUTH_TOKEN}" --header "Content-Type: application/json" --header "Accept: application/json" -d '{"HTTPPort":80,"HTTPSPort":8443,"Arch":"x86_64"}' "https://${UCP_IPADDR}/api/interlock"

# Enable k8s by default
if [ -f /vagrant/env/k8s ]; then
  # CURRENT_CONFIG_NAME will be the name of the currently active UCP configuration
  CURRENT_CONFIG_NAME=$(docker service inspect ucp-agent --format '{{range .Spec.TaskTemplate.ContainerSpec.Configs}}{{if eq "/etc/ucp/ucp.toml" .File.Name}}{{.ConfigName}}{{end}}{{end}}')
  # Collect the current config with `docker config inspect`
  docker config inspect --format '{{ printf "%s" .Spec.Data }}' $CURRENT_CONFIG_NAME > ucp-config.toml
  # Change default node orchestrator to k8s
  sed -i '/default_node_orchestrator =/ s/= .*/= "kubernetes"/' ucp-config.toml
  # NEXT_CONFIG_NAME will be the name of the new UCP configuration
  NEXT_CONFIG_NAME=${CURRENT_CONFIG_NAME%%-*}-$((${CURRENT_CONFIG_NAME##*-}+1))
  # Create the new swarm configuration from the file ucp-config.toml
  docker config create $NEXT_CONFIG_NAME  ucp-config.toml
  # Use the `docker service update` command to remove the current configuration
  # and apply the new configuration to the `ucp-agent` service.
  docker service update -d --config-rm $CURRENT_CONFIG_NAME --config-add source=$NEXT_CONFIG_NAME,target=/etc/ucp/ucp.toml ucp-agent
  # Delete K8s config file
  rm -f /vagrant/env/k8s
fi

# Run Backup
docker run --rm -i --log-driver none --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:${UCP_VERSION} backup --id ${UCP_ID} --root-ca-only --passphrase "secret" > /vagrant/backup.tar

# Wait for UCP to revive
sleep 15
