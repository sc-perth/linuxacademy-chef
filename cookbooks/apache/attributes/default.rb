default["apache"]["sites"]["perth2"] = { "site_title" => "John's website, hello world!", "port" => 80, "domain" => "perth2.mylabserver.com" }
default["apache"]["sites"]["perth2b"] = { "site_title" => "Eat more chicken.", "port" => 80, "domain" => "perth2b.mylabserver.com" }
default["apache"]["sites"]["perth3"] = { "site_title" => "crap", "port" => 80, "domain" => "perth3.mylabserver.com" }

case node["platform"]
	when "centos"
		default["apache"]["package"] = "httpd"
	when "ubuntu"
		default["apache"]["package"] = "apache2"
end

