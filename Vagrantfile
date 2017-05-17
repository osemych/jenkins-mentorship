# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative './vagrant/key_authorization'

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/trusty64'
  authorize_key_for_root config,'~/.ssh/id_rsa.pub'

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = false

  config.chef_zero.enabled = true
  config.chef_zero.chef_server_url = "http://127.0.0.1:8889"
  config.chef_zero.roles = "./chef/roles/"
  config.chef_zero.cookbooks = "./chef/cookbooks/"
  config.chef_zero.environments = "./chef/environments/"
  config.chef_zero.data_bags = "./chef/data_bags/"

  {
    'jenkins'       => '192.168.11.100'
  }.each do |short_name, ip|
    config.vm.define short_name do |host|
      host.vm.network 'private_network', ip: ip
      host.vm.hostname = "#{short_name}.crp.local"
      host.vm.provision :chef_client do |chef|
        chef.environment = "sandbox"
        chef.run_list = ["role[base]"]
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
    'swarm' => [
      'docker-master01',
      'docker-worker01',
      'docker-worker02'
    ]
  }
end
