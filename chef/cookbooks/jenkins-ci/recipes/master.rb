#
# Cookbook Name:: jenkins-ci
# Recipe:: master
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "jenkins::master"
include_recipe "jenkins-ci::plugins"
include_recipe 'maven'

git_client 'default' do
  action :install
end

git_config 'user.email' do
    value 'jenkins@jenkins.sandbox.local'
    scope 'global'
    user 'jenkins'
end

git_config 'user.name' do
    value 'Jenkins CI'
    scope 'global'
    user 'jenkins'
end

# secret = Chef::EncryptedDataBagItem.load_secret("/tmp/vagrant-chef/encrypted_data_bag_secret_key")
# credentials = Chef::EncryptedDataBagItem.load("jenkins", "ad_creds", secret)

init_dir = "#{node['jenkins']['master']['home']}/init.groovy.d"

directory init_dir do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  recursive true
end

template "#{init_dir}/01-cli-disable.groovy" do
  source 'init/01-cli-disable.groovy.erb'
  mode '0755'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
end


template "#{init_dir}/01-install-maven.groovy" do
  source 'init/01-install-maven.groovy.erb'
  mode '0755'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  variables(
    'tools': node['jenkins']['tools']
  )
end

template "#{init_dir}/02-auth.groovy" do
  source 'init/02-auth.groovy.erb'
  mode '0755'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
end

# template "#{init_dir}/02-activedirectory.groovy" do
#   source 'init/02-activedirectory.groovy.erb'
#   mode '0755'
#   owner node['jenkins']['master']['user']
#   group node['jenkins']['master']['group']
#   variables(
#     'ad_domain': credentials['credentials']['ad_domain'],
#     'ad_site': credentials['credentials']['ad_site'],
#     'ad_server': credentials['credentials']['ad_server'],
#     'ad_bindname': credentials['credentials']['ad_bindname'],
#     'ad_bindpasswd': credentials['credentials']['ad_bindpasswd'],
#   )
# end

#jenkins_command 'safe-restart'