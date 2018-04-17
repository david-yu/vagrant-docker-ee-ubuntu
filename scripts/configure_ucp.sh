export UCP_VERSION=3.0.0
export UCP_ID=$(cat /vagrant/env/ucp-id)

# Collect Config file name
CURRENT_CONFIG_NAME=$(docker service inspect ucp-agent --format '{{range .Spec.TaskTemplate.ContainerSpec.Configs}}{{if eq "/etc/ucp/ucp.toml" .File.Name}}{{.ConfigName}}{{end}}{{end}}')
# Collect the current config with `docker config inspect`
docker config inspect --format '{{ printf "%s" .Spec.Data }}' $CURRENT_CONFIG_NAME > ucp-config.toml

if [ -e /vagrant/env/k8s ]; then
  echo 'changing orchestration to swarm'
  # Switch back to swarm
  sed -i '/default_node_orchestrator =/ s/= .*/= "swarm"/' ucp-config.toml
  # Delete K8s config file
  rm -f /vagrant/env/k8s
else
  echo 'changing orchestration to k8s'
  # Change default node orchestrator to k8s
  sed -i '/default_node_orchestrator =/ s/= .*/= "kubernetes"/' ucp-config.toml
  echo 'true' > /vagrant/env/k8s
fi

# NEXT_CONFIG_NAME will be the name of the new UCP configuration
NEXT_CONFIG_NAME=${CURRENT_CONFIG_NAME%%-*}-$((${CURRENT_CONFIG_NAME##*-}+1))
# Create the new swarm configuration from the file ucp-config.toml
docker config create $NEXT_CONFIG_NAME  ucp-config.toml
# Use the `docker service update` command to remove the current configuration
# and apply the new configuration to the `ucp-agent` service.
docker service update -d --config-rm $CURRENT_CONFIG_NAME --config-add source=$NEXT_CONFIG_NAME,target=/etc/ucp/ucp.toml ucp-agent
