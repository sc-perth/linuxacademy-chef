# See http://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "perth"
client_key               "#{current_dir}/perth.pem"
validation_client_name   "semicosmic-validator"
validation_key           "#{current_dir}/semicosmic-validator.pem"
chef_server_url          "https://api.chef.io/organizations/semicosmic"
cookbook_path            ["#{current_dir}/../cookbooks"]
