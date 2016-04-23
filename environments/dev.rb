name "dev"
description = "Development enviornment"

cookbook 'apache', '= 0.1.5'

default_attributes({
	"author" => {
		"name" => "my new author name"
	}
})

