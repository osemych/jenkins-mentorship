#
# Cookbook Name:: jenkins-ci
# Recipe:: dsl-job
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

xml = File.join(Chef::Config[:file_cache_path], 'dsl-hello-world.xml')

cookbook_file xml do
  source 'dsl-hello-world-config.xml'
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode '0644'
  action :create
end

jenkins_job 'dsl-hello-world' do
  config xml
  action :create
  notifies :build, 'jenkins_job[dsl-hello-world]', :delayed
end
