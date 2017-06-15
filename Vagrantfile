# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative './vagrant/key_authorization'

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.omnibus.chef_version = '12.20.3'
  authorize_key_for_root config,'~/.ssh/id_rsa.pub','.ssh/epam.pub'

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = false

  {
    'jenkins' => '192.168.11.100',
    'slave-node01' => '192.168.11.101',
    'slave-node02' => '192.168.11.102'
  }.each do |short_name, ip|
    config.vm.define short_name do |host|
      host.vm.network 'private_network', ip: ip
      host.vm.hostname = "#{short_name}.sandbox.local"
      host.vm.provision :chef_zero do |chef|
        chef.encrypted_data_bag_secret_key_path = "./chef/secret/encrypted_data_bag_secret"
        chef.cookbooks_path = "./chef/cookbooks"
        chef.roles_path = "./chef/roles"
        chef.data_bags_path = "./chef/data_bags"
        chef.nodes_path = "./chef/nodes"
        chef.run_list = ["role[jenkins-master]"] if short_name == "jenkins"
        chef.run_list = ["role[jenkins-slave]"] if short_name.include? "slave"
      end
      host.vm.provider "virtualbox" do |vbox|
        vbox.cpus = 2
        vbox.memory = 1024
        vbox.memory = 2048 if short_name == "jenkins"
      end
    end
  end

  {
    'docker-master01' => '192.168.33.150',
    'docker-worker01' => '192.168.33.151',
    'docker-worker02' => '192.168.33.152'
  }.each do |short_name, ip|
    config.vm.define short_name do |host|
      host.vm.network 'private_network', ip: ip
      host.vm.hostname = "#{short_name}.crp.local"
      host.vm.provision "shell", path: "./init/docker.sh"
      host.vm.provider "virtualbox" do |vbox|
        vbox.cpus = 2
        vbox.memory = 1024
        vbox.memory = 512 if short_name.include? "docker-master"
      end
    end
  end

  config.group.groups = {
    'jenkins' => [
      'jenkins',
      'slave-node01',
      'slave-node02'
    ],
    'swarm' => [
      'docker-master01',
      'docker-worker01',
      'docker-worker02'
    ]
  }
end
