
.PHONEY: all start stop snap rollback

all: help

help:    ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

start:
	@vagrant up ucp worker-node1 worker-node2

ucp:
	@vagrant up ucp

k8s:
	@vagrant up ucp
	@vagrant ssh ucp -c 'sudo ./configure_ucp.sh'
	echo 'true' > env/k8s
	@vagrant up worker-node1 worker-node2

mixed:
	@vagrant up ucp worker-node1
	echo 'true' > env/k8s
	@vagrant ssh ucp -c 'sudo ./configure_ucp.sh'
	@vagrant up worker-node2

workers:
	@vagrant up worker-node1 worker-node2

dtr:
	# Configure orchestrator to Swarm
	@vagrant ssh ucp -c 'sudo ./configure_ucp.sh'
	@vagrant up dtr

gitlab:
	@vagrant up gitlab

config-gitlab:
	./scripts/configure_gitlab.sh

rm-gitlab:
	@vagrant destroy gitlab

jenkins:
	@vagrant up jenkins

rm-jenkins:
	@vagrant destroy -f jenkins

destroy-workers:
	@vagrant destroy -f worker-node1 worker-node2

stop:
	@vagrant halt ucp dtr worker-node1 worker-node2 jenkins

status:
	@vagrant status

snap: ## snapshot all vms
	./scripts/snapshot.sh

rollback: ## rollback to the previous snapshot
	./scripts/rollback.sh

destroy:
	@vagrant destroy -f ucp dtr worker-node1 worker-node2 jenkins
