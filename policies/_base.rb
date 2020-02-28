

# Where to find external cookbooks:
default_source :supermarket, 'https://supermarket.chef.io/'
default_source :chef_repo,   './../test/cookbooks'

cookbook 'ignite', path: './../'
