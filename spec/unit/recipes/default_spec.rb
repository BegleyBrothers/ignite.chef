# SPDX-License-Identifier: Apache 2.0
# Copyright:: 2020, Begley Brothers.
#
# Cookbook:: weaveworks-ignite
# Spec:: default
#

require 'spec_helper'

describe 'weaveworks-ignite::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'ubuntu', '18.04'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When all attributes are default, on Ubuntu 19.10' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'ubuntu', '19.10'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
