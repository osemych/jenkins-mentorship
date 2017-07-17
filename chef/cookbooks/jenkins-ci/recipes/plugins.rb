#
# Cookbook Name:: jenkins-ci
# Recipe:: plugins
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
plugins_fname = 'plugins.list'
plugins = File.join(Chef::Config[:file_cache_path], 'plugins.list')

Chef::Log.info("Uploading plugin list to #{plugins}")

cookbook_file plugins do
  source 'plugins.list'
  mode '0644'
end.run_action(:create)

if File.exists?("#{plugins}")
    File.open("#{plugins}", "r").each_line do |plugin|
        (plugin_name, plugin_ver) = plugin.split(/:/)
        Chef::Log.info("Jenkins plugin #{plugin_name} #{plugin_ver} will be installed")
        jenkins_plugin "#{plugin_name}" do
            version "#{plugin_ver}"
            install_deps true
        end
    end
end

#jenkins_command 'safe-restart'
