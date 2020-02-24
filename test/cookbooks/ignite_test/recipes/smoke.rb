#
# Cookbook:: ignite_test
# Recipe:: smoke
#
# Copyright:: 2020, Begley Brothers Inc., All Rights Reserved.

# The `ignite` command is used by the InSpec controls
ignite_installation_binary 'default'

ignite_service 'ignited' do
  action [:create, :start]
end

# Create a VM (generate UUID with SecureRandom.alphanumeric(16))...
template 'Smoke test declarative VM' do
  source 'smoke/smoke-test.yml.erb'
  path '/etc/firecracker/manifests/smoke-test.yml'
  helper(:uuid) { 'RPfrdQXMFFadVN6t'.downcase }
  owner 'root'
  group 'root'
  mode '0755'
  cookbook 'ignite_test'
  action :create
end

# Inspec tests verify the VM is as defined.
