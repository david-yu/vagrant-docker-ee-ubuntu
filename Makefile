
.PHONEY: all start stop snap rollback

all: help

help:    ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

start:
	@vagrant up haproxy ucp-node1 dtr-node1 worker-node1 worker-node2

stop:
	@vagrant halt haproxy ucp-node1 dtr-node1 worker-node1 worker-node2

get: ## get all dependencies
	@ansible-galaxy install -r ansible/requirements.yml -p ansible/roles

snap: ## snapshot all vms
	./scripts/snapshot.sh

rollback: ## rollback to the previous snapshot
	./scripts/rollback.sh

build:
	@vagrant provision

etc/:
	./scripts/etc-setup.sh

test: ## quick env reachability test
	@ansible all -m ping
destroy:
	@vagrant destroy haproxy ucp-node1 ucp-node2 ucp-node3 dtr-node1 worker-node1 worker-node2
