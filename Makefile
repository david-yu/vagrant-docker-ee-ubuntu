
.PHONEY: all start stop snap rollback

all: help

help:    ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

start:
	@vagrant up ucp dtr worker-node1 worker-node2

dtr:
	@vagrant up dtr

gitlab:
	@vagrant up gitlab

rm-gitlab:
	@vagrant destroy gitlab

jenkins:
	@vagrant up jenkins

rm-jenkins:
	@vagrant destroy -f jenkins

workers:
	@vagrant up worker-node1 worker-node2

destroy-workers:
	@vagrant destroy -f worker-node1 worker-node2

stop:
	@vagrant halt ucp dtr worker-node1 worker-node2 jenkins

snap: ## snapshot all vms
	./scripts/snapshot.sh

rollback: ## rollback to the previous snapshot
	./scripts/rollback.sh

destroy:
	@vagrant destroy -f ucp dtr worker-node1 worker-node2 jenkins
