# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

#
# Cookbook:: ignite_test
# Recipe:: smoke
#

# The `ignite` command is used by the InSpec controls
ignite_installation_binary 'default'

ignite_service 'ignited' do
  action [:create, :start]
end

# Create a VM (generate UUID with SecureRandom.alphanumeric(16))...
template 'Regression test declarative VM using YAML' do
  source 'issues/542/manifest.yml.erb'
  path '/etc/firecracker/manifests/issue-542.yml'
  helper(:uuid) { 'RPfrdQXMFFadVN6t'.downcase }
  owner 'root'
  group 'root'
  mode '0755'
  cookbook 'ignite_test'
  action :create
end

# Inspec tests verify the VM is as defined.
# See test/integration/<recipe-name>/inspec
