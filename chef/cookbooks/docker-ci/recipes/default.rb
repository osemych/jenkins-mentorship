#
# Cookbook Name:: docker-ci
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

docker_service 'default' do
  host [ "tcp://0.0.0.0:4243", 'unix:///var/run/docker.sock' ]
  action [:create, :start]
end

docker_image 'jenkinsci/jnlp-slave' do
  action :pull
end

# docker_image 'evarga/jenkins-slave' do
#   action :pull
# end

