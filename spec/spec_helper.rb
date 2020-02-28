# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

require 'chefspec'
require 'chefspec/policyfile'

ChefSpec::Coverage.start!

if ENV['CI']
  require 'coveralls'
  require 'simplecov'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  Coveralls.wear!
end

class RSpecHelper
  class<<self
    attr_accessor :current_example
  end
  def self.reset!
    @current_example = nil
  end
end

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.policyfile_path = File.join(Dir.pwd, 'policies', 'chefspec.rb')
  config.before :each do
    RSpecHelper.reset!
    RSpecHelper.current_example = self
  end
end

at_exit { ::ChefSpec::Coverage.report! }
