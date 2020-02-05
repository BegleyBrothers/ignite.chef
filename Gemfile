# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# SPDX-License-Identifier: MIT
# Copyright:: 2020, Begley Brothers.
#

source 'https://rubygems.org'

gem 'chef'
gem 'chef-cli'
gem 'kitchen-inspec'
gem 'inspec'
gem 'rake'

group :development do
  # lefthook related:
  gem 'lefthook'
  gem 'rubocop'
  # gem 'pronto'
  # gem 'pronto-rubocop', require: false
  # gem 'pronto-flay', require: false
end

group :integration do
  gem 'test-kitchen'
end

group :dokken do
  gem 'kitchen-dokken'
end
