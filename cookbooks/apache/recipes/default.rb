#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Check for selinux
system("getenforce")
if $?.exitstatus == 0
	selinux = true
	print "SELinux detected\n"
else
	selinux = false
	print "SELinux not detected\n"
end

# Platform specific adaptations
if node["platform"] == "ubuntu"
	execute "apt-get update -y" do
	end
	apache_dir = "/etc/apache2/sites-enabled"
elsif node["platform"] == "centos"
	apache_dir = "/etc/httpd/conf.d"
end

package "apache" do
	package_name node["apache"]["package"]
end

node["apache"]["sites"].each do |sitename, data|
	document_root = "/content/sites/#{sitename}"

	# Generate document_root directory structure
	directory document_root do
		mode "0755"
		recursive true
	end

	# Create & populate site's index.html
	template "#{document_root}/index.html" do
		source "index.html.erb"
		mode "0644"
		variables(
			:site_title => data["site_title"],
			:comingsoon => "coming soon"
		)
	end

	# Set selinux context on document_root, if selinux detected
	if selinux
		execute 'selinux' do
			command "chcon -Rv --type=httpd_sys_content_t #{document_root}"
			returns 0
		end
	end

	# Create & generate site's apache config file
	template "#{apache_dir}/#{sitename}.conf" do
		source "vhost.erb"
		mode "0644"
		variables(
			:document_root => document_root,
			:port 	=> data["port"],
			:domain	=> data["domain"],
			:platform => node["platform"]
		)
		notifies :restart, "service[httpd]"
	end
end

cleanup_files = ["welcome.conf", "README", "userdir.conf", "autoindex.conf"]

cleanup_files.each do |file|
	target = "#{apache_dir}/#{file}"
	execute "rm #{target}" do
		only_if do
			File.exist?("#{target}")
		end
		notifies :restart, "service[httpd]"
	end
end


# Start service resource
service "httpd" do
	service_name node["apache"]["package"]
	action [:enable, :start]
end
# End service resource


#include_recipe "php::default"

