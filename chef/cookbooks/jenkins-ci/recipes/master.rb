#
# Cookbook Name:: jenkins-ci
# Recipe:: master
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "jenkins::master"
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

jenkins_plugin 'junit' do
    version '1.2'
    install_deps false
end

jenkins_plugin 'matrix-project' do
    version '1.7.1'
    install_deps false
end

jenkins_plugin 'scm-api' do
    version '2.1.0'
    install_deps false
end

jenkins_plugin 'credentials' do
    version '2.1.13'
    install_deps false
end

jenkins_plugin 'display-url-api' do
    version '2.0'
    install_deps false
end

jenkins_plugin 'token-macro' do
    version '2.1'
    install_deps false
end

jenkins_plugin 'workflow-scm-step' do
    version '2.4'
    install_deps false
end

jenkins_plugin 'workflow-step-api' do
    version '2.9'
    install_deps false
end

jenkins_plugin 'ssh-credentials' do
    version '1.13'
    install_deps false
end

jenkins_plugin 'plain-credentials' do
    version '1.4'
    install_deps false
end

jenkins_plugin 'git-client' do
    version '2.4.5'
    install_deps false
end

jenkins_plugin 'mailer' do
    version '1.20'
    install_deps false
end

jenkins_plugin 'script-security' do
    version '1.27'
    install_deps false
end

jenkins_plugin 'structs' do
    version '1.6'
    install_deps false
end

jenkins_plugin 'git' do
    version '3.3.0'
    install_deps false
end

jenkins_plugin 'job-dsl'

jenkins_script 'add_maven' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    def instance = Jenkins.getInstance()

    def mavenTask = Jenkins.instance.getExtensionList(
      hudson.tasks.Maven.DescriptorImpl.class
    )[0]
    mavenTask.setInstallations(
      new hudson.tasks.Maven.MavenInstallation(
        "Maven", "/usr/local/maven-3.5.0", []
      )
    )
    mavenTask.save()
  EOH
end

jenkins_command 'safe-restart'