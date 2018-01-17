export UCP_VERSION=3.0.0-beta2
export UCP_ID=$(cat /vagrant/env/ucp-id)

# Enable k8s by default
if [ -f /vagrant/env/k8s ]; then
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
else
  CURRENT_CONFIG_NAME=$(docker service inspect ucp-agent --format '{{range .Spec.TaskTemplate.ContainerSpec.Configs}}{{if eq "/etc/ucp/ucp.toml" .File.Name}}{{.ConfigName}}{{end}}{{end}}')
  # Collect the current config with `docker config inspect`
  docker config inspect --format '{{ printf "%s" .Spec.Data }}' $CURRENT_CONFIG_NAME > ucp-config.toml
  # Change default node orchestrator to k8s
  sed -i '/default_node_orchestrator =/ s/= .*/= "swarm"/' ucp-config.toml
  # NEXT_CONFIG_NAME will be the name of the new UCP configuration
  NEXT_CONFIG_NAME=${CURRENT_CONFIG_NAME%%-*}-$((${CURRENT_CONFIG_NAME##*-}+1))
  # Create the new swarm configuration from the file ucp-config.toml
  docker config create $NEXT_CONFIG_NAME  ucp-config.toml
  # Use the `docker service update` command to remove the current configuration
  # and apply the new configuration to the `ucp-agent` service.
  docker service update -d --config-rm $CURRENT_CONFIG_NAME --config-add source=$NEXT_CONFIG_NAME,target=/etc/ucp/ucp.toml ucp-agent
  # Delete K8s config file
fi

# Run Backup
docker run --rm -i --log-driver none --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:${UCP_VERSION} backup --id ${UCP_ID} --root-ca-only --passphrase "secret" > /vagrant/backup.tar
