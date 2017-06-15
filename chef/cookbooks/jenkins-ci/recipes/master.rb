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

secret = Chef::EncryptedDataBagItem.load_secret("/tmp/vagrant-chef/encrypted_data_bag_secret_key")
credentials = Chef::EncryptedDataBagItem.load("jenkins", "ad_creds", secret)

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

jenkins_script 'ad_auth' do
    command <<-EOH.gsub(/^ (4)/, '')
        import jenkins.model.*
        import jenkins.security.*
        import hudson.security.*
        import hudson.plugins.active_directory.*

        def instance = Jenkins.getInstance()
        String domain = "#{credentials["credentials"]["ad_domain"]}"
        String site = "#{credentials["credentials"]["ad_site"]}"
        String server = "#{credentials["credentials"]["ad_server"]}"
        String bindName = "#{credentials["credentials"]["ad_bindname"]}"
        String bindPassword = "#{credentials["credentials"]["ad_bindpasswd"]}"
        def adrealm = new ActiveDirectorySecurityRealm(domain, site, bindName, bindPassword, server, GroupLookupStrategy.RECURSIVE)
        instance.setSecurityRealm(adrealm)
//        def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
//        strategy.setAllowAnonymousRead(true)
//        instance.setAuthorizationStrategy(strategy)
        instance.save()
    EOH
end

jenkins_command 'safe-restart'