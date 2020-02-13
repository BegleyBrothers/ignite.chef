# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# SPDX-License-Identifier: Apache 2.0
# Copyright:: 2020, Begley Brothers.
#

source 'https://rubygems.org'

# gem 'chef'

gem 'rake'

group :development do
  # gem 'chef-cli'
  gem 'chef-dk'
  gem 'chefspec'
  gem 'cookstyle'
  gem 'coveralls', require: false
  gem 'simplecov'
  gem 'kitchen-inspec'
  gem 'inspec'
  gem 'rspec_junit_formatter'
  gem 'kitchen-vagrant' # ?already in chef-dk
  # lefthook related:
  gem 'lefthook'
  gem 'rubocop'
  # gem 'pronto'
  # gem 'pronto-rubocop', require: false
  # gem 'pronto-flay', require: false
end

group :integration do
  gem 'test-kitchen'
  # gem 'kitchen-local', :git => 'https://github.com/gengo/kitchen-local.git'
  gem 'kitchen-docker', '> 2.8.0'
end

# group :dokken do
#   gem 'kitchen-dokken'
# end
