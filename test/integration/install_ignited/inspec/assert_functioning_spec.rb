# SPDX-License-Identifier: Apache-2.0
# Copyright:: (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

describe command('/usr/bin/ignited version') do
  its(:exit_status) { should eq 0 }
end
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
