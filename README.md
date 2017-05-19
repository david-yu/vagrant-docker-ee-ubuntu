Vagrant Virtualbox setup for Docker EE Engine on CentOS 7.3
========================

An exercise on installing Docker EE Engine and properly configuring Device Mapper on CentOS, which may be helpful for walking through the install and configuration of Docker EE Engine before actually doing so in production environments. This vagrant file is provided strictly for educational purposes.

## Download vagrant from Vagrant website

```
https://www.vagrantup.com/downloads.html
```

## Install Virtual Box

```
https://www.virtualbox.org/wiki/Downloads
```

## Download CentOS 7 box
```
$ vagrant init centos/7
```

## Create files in project to store environment variables with custom values for use by Vagrant
```
ee_url
```

## Install [vagrant-landrush](https://github.com/vagrant-landrush/landrush) plugin
```

$ vagrant plugin install landrush
$ vagrant plugin install vagrant-hostsupdater
$ vagrant plugin install vagrant-multiprovider-snap
```

## Bring up nodes

```
$ vagrant up haproxy ucp-node1 ucp-node2 ucp-node3 dtr-node1 worker-node1
# Flush Mac's DNS cache
$ sudo killall -HUP mDNSResponder
```

## Stop nodes

```
$ vagrant halt haproxy ucp-node1 ucp-node2 ucp-node3 dtr-node1 worker-node1
```

## Destroy nodes

```
$ vagrant destroy haproxy ucp-node1 ucp-node2 ucp-node3 dtr-node1 worker-node1
```

## Snapshot nodes

```
$ vagrant snapshot save ucp-node1 ucp-node1-snapshot
```
