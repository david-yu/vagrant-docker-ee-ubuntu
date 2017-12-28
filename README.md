Vagrant Virtualbox setup for Docker EE 2.0 on Ubuntu Xenial 16.04
========================

This vagrant file is provided strictly for demonstration purposes to help setup a cluster environment that installs Docker EE, UCP, and DTR with embedded DNS. This can be used as a demo environment on your local machine, when internet access is not present.

After running `vagrant up`:
- UCP will be accessible from `https:\\ucp.local` resolved through DNS
- DTR will be accessible from `https:\\dtr.local` resolved through DNS
- If installed, HAProxy Stats will be accessible from `https:\\haproxy.local:9000` (login: admin/admin)

This template will also setup the VMs with static ip addresses as follows (if IP addresses are already in use, change them inside of the Vagrantfile):
- `ucp-node1` (UCP manager node): 172.28.128.31
- `ucp-node2` (UCP manager node2): 172.28.128.32 - Optional
- `ucp-node3` (UCP manager node3): 172.28.128.33 - Optional
- `dtr-node1` (DTR replica): 172.28.128.34
- `worker-node1` (Worker node): 172.28.128.35
- `worker-node2` (Worker node): 172.28.128.36
- `gitlab-node` (Gitlab node): 172.28.128.37
- `haproxy` (HA Proxy node): 172.28.128.30 - Optional
- `jenkins` (Jenkins node): 172.28.128.38 - Optional

DNS entries for landrush:
- `dtr.local`: 172.28.128.30
- `ucp.local`: 172.28.128.30
- `wordpress.local`: 172.28.128.31
- `jenkins.local`: 172.28.128.31
- `nodeapp.local`: 172.28.128.31
- `visualizer.local`: 172.28.128.31
- `gitlab.local`: 172.28.128.31

## Download vagrant from Vagrant website

```
https://www.vagrantup.com/downloads.html
```

## Install Virtual Box

```
https://www.virtualbox.org/wiki/Downloads
```

## Create files in the `/env` folder to store environment variables with custom values for use by Vagrant
```
ee_url
ucp_username
ucp_password
```

For the `ee_url` file make sure the format of the ee_url is like the following
```
https://storebits.docker.com/ee/linux/sub-xxx-xxx-xxx-xxx-xxx
```

## Provide Docker EE license in `/env` folder (will fail if not provided)
```
docker_subscription.lic
```

## Install [vagrant-landrush](https://github.com/vagrant-landrush/landrush) plugin
```

vagrant plugin install landrush
vagrant plugin install vagrant-hostsupdater
vagrant plugin install vagrant-multiprovider-snap
```

## Bring up nodes

If you are thinking of customizing the start up of the cluster (i.e. no DTR, HA UCP, etc) modify the `Makefile` to describe the `start`, `stop`, and `destroy` targets to manage certain nodes, if you only need a UCP manager node you can just edit the file to have the following entry for the `start` target.

```
start:
	@vagrant up haproxy ucp worker-node1 worker-node2 

...

destroy:
	@vagrant destroy -f ucp worker-node1 worker-node2
```

Then you can run from the CLI

```
make start
```

## Stop nodes

```
make stop
```

## Destroy nodes

```
make destroy
```

## Snapshot nodes

```
# Take initial snapshot of nodes
make snap

# Restore initial snapshot
make rollback
```
