# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# SPDX-License-Identifier: MIT
# Copyright:: 2020, Begley Brothers.
#

source 'https://rubygems.org'

# gem 'chef'

gem 'rake'

group :development do
  # gem 'chef-cli'
  gem 'chef-dk'
  gem 'kitchen-inspec'
  gem 'inspec'
  # lefthook related:
  gem 'lefthook'
  gem 'rubocop'
  # gem 'pronto'
  # gem 'pronto-rubocop', require: false
  # gem 'pronto-flay', require: false
end

group :integration do
  gem 'test-kitchen'
  gem 'kitchen-local', :git => 'https://github.com/gengo/kitchen-local.git'
  gem 'kitchen-docker'
end

group :dokken do
  gem 'kitchen-dokken'
end
