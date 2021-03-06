# -*- mode: ruby -*-
# vi: set ft=ruby :
# SPDX-License-Identifier: Apache-2.0
# Copyright:: (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

# Available Rake tasks:
#
# $ rake -T
#
# More info at https://github.com/ruby/rake/blob/master/doc/rakefile.rdoc
#

# For CircleCI
require 'bundler/setup'

# Style tests. Rubocop and CookStyle
namespace :style do
  require 'cookstyle'
  require 'rubocop/rake_task'
  desc 'RuboCop Cookstyle'
  RuboCop::RakeTask.new(:chef) do |task|
    task.patterns = ['attributes/**/*.rb',
                     'libraries/**/*.rb',
                     'policies/**/*.rb',
                     'recipes/**/*.rb',
                     'spec/**/*.rb',
                     'test/integration/**/*.rb']
    task.options << '--auto-correct'
    task.options << '--display-cop-names'
  end
end

# Rspec and ChefSpec
namespace :unit do
  desc 'Unit Tests (Rspec & ChefSpec)'
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:rspec)

  desc 'Unit Tests for CircleCI'
  RSpec::Core::RakeTask.new(:circleci_rspec) do |test|
    # t.fail_on_error = false
    test.rspec_opts = '--no-drb -r rspec_junit_formatter --format RspecJunitFormatter -o ${CIRCLE_TEST_REPORTS:-./}/rspec/junit.xml'
  end
end

desc 'Circle CI Tasks'
# Digital ocean tests are costly
# task circleci: %w(style:chef unit:circleci_rspec integration:digitalocean)
task circleci: %w(style:chef unit:circleci_rspec)

desc 'Rubocop, CookStyle & ChefSpec'
task default: %w(style:chef unit:rspec)

desc 'Rubocop & CookStyle'
task style_only: %w(style:chef)

desc 'Run Test Kitchen integration tests'
namespace :integration do
  # Gets a collection of instances.
  #
  # @param regexp [String] regular expression to match against instance names.
  # @param config [Hash] configuration values for the `Kitchen::Config` class.
  # @return [Collection<Instance>] all instances.
  def kitchen_instances(regexp, config)
    instances = Kitchen::Config.new(config).instances
    return instances if regexp.nil? || regexp == 'all'

    instances.get_all(Regexp.new(regexp))
  end

  # Runs a test kitchen action against some instances.
  #
  # @param action [String] kitchen action to run (defaults to `'test'`).
  # @param regexp [String] regular expression to match against instance names.
  # @param loader_config [Hash] loader configuration options.
  # @return void
  def run_kitchen(action, regexp, loader_config = {})
    action = 'test' if action.nil?
    require 'kitchen'
    Kitchen.logger = Kitchen.default_file_logger
    config = { loader: Kitchen::Loader::YAML.new(loader_config) }
    kitchen_instances(regexp, config).each { |i| i.send(action) }
  end

  # Default to Policyfile
  def product_name
    'Policyfile'
  end

  # Returns a list of *-policyfile.rb
  def policies
    FileList["#{product_name}.rb"]
  end

  desc 'Compile all Policfile.rb'
  task :compile_policies do
    rm Dir.glob('*.lock.json')
    policies.each do |policyfile|
      sh 'chef', 'install', policyfile
    end
  end

  desc 'Run integration tests with kitchen-digitalocean'
  task :digitalocean, [:action, :regexp] => [:compile_policies] do |_t, args|
    run_kitchen(args.action, args.regexp, local_config: '.kitchen.yml')
  end
end

#task default: %w(integration:digitalocean)
