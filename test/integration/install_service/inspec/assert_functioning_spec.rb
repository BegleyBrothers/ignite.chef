# SPDX-License-Identifier: Apache-2.0
# Copyright:: (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

#  service named 'ignite-ignited'

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end
describe package('containerd') do
  it { should be_installed }
end

describe process('containerd') do
  it { should be_running }
end

describe service('ignite-ignited') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe upstart_service('ignite-ignited') do
  it { should_not be_enabled }
  it { should be_installed }
  it { should be_running }
end

describe runit_service('ignite-ignited') do
  it { should be_enabled }
  it { should be_installed }
  it { should be_running }
end
