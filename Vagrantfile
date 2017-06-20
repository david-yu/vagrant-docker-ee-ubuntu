# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.

    # Docker EE node for ubuntu 7.3
    config.vm.define "haproxy" do |haproxy_node|
      haproxy_node.vm.box = "ubuntu/xenial64"
      haproxy_node.vm.network "private_network", ip: "172.28.128.30"
      haproxy_node.vm.hostname = "haproxy.local"
      haproxy_node.hostsupdater.aliases = ["ucp.local", "dtr.local"]
      config.vm.provider :virtualbox do |vb|
         vb.customize ["modifyvm", :id, "--memory", "1024"]
         vb.customize ["modifyvm", :id, "--cpus", "1"]
         vb.name = "ubuntu-haproxy-node"
      end
      haproxy_node.landrush.enabled = true
      haproxy_node.landrush.tld = 'local'
      haproxy_node.landrush.host 'dtr.local', '172.28.128.30'
      haproxy_node.landrush.host 'ucp.local', '172.28.128.30'
      haproxy_node.vm.provision "shell", inline: <<-SHELL
       sudo apt-get update
       sudo apt-get install -y apt-transport-https ca-certificates ntpdate
       sudo ntpdate -s time.nist.gov
       sudo apt-get install -y software-properties-common
       sudo add-apt-repository ppa:vbernat/haproxy-1.7
       sudo apt-get update
       sudo apt-get install -y haproxy
       ifconfig enp0s8 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' > /vagrant/haproxy-node
       sudo sed -i '/module(load="imudp")/s/^#//g' /etc/rsyslog.conf
       sudo sed -i '/input(type="imudp" port="514")/s/^#//g' /etc/rsyslog.conf
       sudo service rsyslog restart
       sudo cp /vagrant/files/haproxy.cfg /etc/haproxy/haproxy.cfg
       sudo service haproxy restart
      SHELL
    end

    # Docker EE node for ubuntu 7.3
    config.vm.define "ucp-node1" do |ubuntu_ucp_node1|
      ubuntu_ucp_node1.vm.box = "ubuntu/xenial64"
      ubuntu_ucp_node1.vm.network "private_network", ip: "172.28.128.31"
      ubuntu_ucp_node1.landrush.tld = 'local'
      ubuntu_ucp_node1.vm.hostname = "ucp-node1.local"
      ubuntu_ucp_node1.landrush.enabled = true
      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2500"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "ubuntu-ucp-node1"
      end
      ubuntu_ucp_node1.vm.provision "shell", inline: <<-SHELL
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates ntpdate
        sudo ntpdate -s time.nist.gov
        sudo cp /vagrant/scripts/install_ee.sh .
        sudo cp /vagrant/scripts/install_ucp.sh .
        sudo cp /vagrant/scripts/create_tokens.sh .
        sudo chmod +x install_ee.sh
        sudo chmod +x install_ucp.sh
        sudo chmod +x create_tokens.sh
        ./install_ee.sh
        ./install_ucp.sh
        ./create_tokens.sh
     SHELL
    end

    # Docker EE node for ubuntu 7.3
    config.vm.define "ucp-node2" do |ubuntu_ucp_node2|
      ubuntu_ucp_node2.vm.box = "ubuntu/xenial64"
      ubuntu_ucp_node2.vm.network "private_network", ip: "172.28.128.32"
      ubuntu_ucp_node2.landrush.tld = 'local'
      ubuntu_ucp_node2.vm.hostname = "ucp-node2.local"
      ubuntu_ucp_node2.landrush.enabled = true
      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2500"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "ubuntu-ucp-node2"
      end
      ubuntu_ucp_node2.vm.provision "shell", inline: <<-SHELL
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates ntpdate
        sudo ntpdate -s time.nist.gov
        sudo cp /vagrant/scripts/install_ee.sh .
        sudo cp /vagrant/scripts/join_manager.sh .
        sudo chmod +x install_ee.sh
        sudo chmod +x join_manager.sh
        ./install_ee.sh
        ./join_manager.sh
      SHELL
    end

    # Docker EE node for ubuntu 7.3
    config.vm.define "ucp-node3" do |ubuntu_ucp_node3|
      ubuntu_ucp_node3.vm.box = "ubuntu/xenial64"
      ubuntu_ucp_node3.vm.network "private_network", ip: "172.28.128.33"
      ubuntu_ucp_node3.landrush.tld = 'local'
      ubuntu_ucp_node3.vm.hostname = "ucp-node3.local"
      ubuntu_ucp_node3.landrush.enabled = true
      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "ubuntu-ucp-node3"
      end
      ubuntu_ucp_node3.vm.provision "shell", inline: <<-SHELL
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates ntpdate
        sudo ntpdate -s time.nist.gov
        sudo cp /vagrant/scripts/install_ee.sh .
        sudo cp /vagrant/scripts/join_manager.sh .
        sudo chmod +x install_ee.sh
        sudo chmod +x join_manager.sh
        ./install_ee.sh
        ./join_manager.sh
     SHELL
    end

    # Docker EE node for ubuntu 7.3
    config.vm.define "dtr-node1" do |ubuntu_dtr_node1|
      ubuntu_dtr_node1.vm.box = "ubuntu/xenial64"
      ubuntu_dtr_node1.vm.network "private_network", ip: "172.28.128.34"
      ubuntu_dtr_node1.landrush.tld = 'local'
      ubuntu_dtr_node1.vm.hostname = "dtr-node1.local"
      ubuntu_dtr_node1.landrush.enabled = true
      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "ubuntu-dtr-node1"
      end
      ubuntu_dtr_node1.vm.provision "shell", inline: <<-SHELL
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates ntpdate
        sudo ntpdate -s time.nist.gov
        sudo cp /vagrant/scripts/install_ee.sh .
        sudo cp /vagrant/scripts/join_worker.sh .
        sudo cp /vagrant/scripts/install_dtr.sh .
        sudo cp /vagrant/scripts/prepoluate_dtr.sh .
        sudo chmod +x install_ee.sh
        sudo chmod +x join_worker.sh
        sudo chmod +x install_dtr.sh
        sudo chmod +x prepoluate_dtr.sh
        ./install_ee.sh
        ./join_worker.sh
        ./install_dtr.sh
      SHELL
    end

    # Docker EE node for ubuntu 7.3
    config.vm.define "worker-node1" do |ubuntu_worker_node1|
      ubuntu_worker_node1.vm.box = "ubuntu/xenial64"
      ubuntu_worker_node1.vm.network "private_network", ip: "172.28.128.35"
      ubuntu_worker_node1.landrush.tld = 'local'
      ubuntu_worker_node1.vm.hostname = "worker-node1.local"
      ubuntu_worker_node1.landrush.enabled = true
      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.name = "ubuntu-worker-node1"
      end
      ubuntu_worker_node1.vm.provision "shell", inline: <<-SHELL
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates ntpdate
        sudo ntpdate -s time.nist.gov
        sudo cp /vagrant/scripts/install_ee.sh .
        sudo cp /vagrant/scripts/join_worker.sh .
        sudo chmod +x install_ee.sh
        sudo chmod +x join_worker.sh
        ./install_ee.sh
        ./join_worker.sh
     SHELL
    end

end
