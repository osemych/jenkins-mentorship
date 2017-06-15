#
# Cookbook Name:: jenkins-ci
# Recipe:: slave
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'maven'

# Create the Jenkins user
user node['jenkins']['slave']['user'] do
  home node['jenkins']['slave']['home']
  system node['jenkins']['slave']['use_system_accounts'] # ~FC048
end

# Create the Jenkins group
group node['jenkins']['slave']['group'] do
  members node['jenkins']['slave']['user']
  system node['jenkins']['slave']['use_system_accounts'] # ~FC048
end

# Create the home directory
directory node['jenkins']['slave']['home'] do
  owner     node['jenkins']['slave']['user']
  group     node['jenkins']['slave']['group']
  mode      '0755'
  recursive true
end

# Create the log directory
directory node['jenkins']['slave']['log_directory'] do
  owner     node['jenkins']['slave']['user']
  group     node['jenkins']['slave']['group']
  mode      '0755'
  recursive true
end

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

jenkins_jnlp_slave node['hostname'] do
  description     'On-demand slave node'
  remote_fs       '/home/jenkins'
  executors       2
  usage_mode      'normal'
  availability    'demand'
  in_demand_delay 1
  idle_delay      1
  labels          ['slave', 'linux']
end