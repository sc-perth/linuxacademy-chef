name "base"
description "Role of recipies to be on all servers"
run_list "recipe[security]", "recipe[localusers]"
