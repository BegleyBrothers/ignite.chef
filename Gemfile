# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# SPDX-License-Identifier: Apache 2.0
# Copyright:: 2020, Begley Brothers.
#

source 'https://rubygems.org'

group :development do
  # gem 'chef-cli'
  gem 'chef-dk'
  gem 'cookstyle'
  gem 'coveralls', require: false
  gem 'inspec'
  gem 'kitchen-transport-speedy'
  gem 'kitchen-vagrant' # ?already in chef-dk
  gem 'lefthook'
  gem 'rake'
  gem 'rspec_junit_formatter'
  # lefthook related:
  gem 'rubocop'
  gem 'simplecov'
  # gem 'pronto'
  # gem 'pronto-rubocop', require: false
  # gem 'pronto-flay', require: false
end

group :integration do
  gem 'test-kitchen'
  gem 'kitchen-digitalocean'
  gem 'kitchen-inspec'
  gem 'kitchen-transport-rsync'
end

# group :dokken do
#   gem 'kitchen-dokken'
# end
