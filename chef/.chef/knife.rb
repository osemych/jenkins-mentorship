current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "probook"
client_key               "#{current_dir}/chef_zero.pem"
chef_server_url          "http://127.0.0.1:8889"
cookbook_path            ["#{current_dir}/../cookbooks"]
