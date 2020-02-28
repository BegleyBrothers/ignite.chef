# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

require 'spec_helper'

describe 'ignite_test::install_binary' do
  before(:each) do
    stubs_for_provider('ignited_binary[default]') do |provider|
      allow(provider).to receive_shell_out('/usr/bin/ignite version', stdout: 'Ignite version 0.0.0, build 0ffa825')
      allow(provider).to receive(:name).and_return('default')
    end
  end
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(platform:  'ubuntu',
                             version:   '18.04',
                             step_into: ['ignited_binary']).converge('ignite_test::service', described_recipe)
  end

  context 'testing default action, default properties' do
    it 'installs ignited' do
      expect(chef_run).to install_ignited_binary('default')
    end
    it 'installs a remote file' do
      expect(chef_run).to create_remote_file('/usr/bin/ignited')
    end
  end

  # Coverage of most recent ignite versions (3 most recent minor numbers).
  # Once 1.0 is released track 3 most recent major release numbers.
  # To ensure test coverage and backwards compatibility
  # with any changes in naming convention.
  # List generated from:
  # https://github.com/weaveworks/ignite/releases
  #
  # Example:
  # https://github.com/weaveworks/ignite/releases/download/v0.6.3/ignite-arm64

  context 'binary file names for Ubuntu 18.04' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform:  'ubuntu',
                               version:   '18.04',
                               step_into: ['ignited_binary']).converge('ignite_test::service', described_recipe)
    end

    it 'resolves URI to ignited binary file URL.' do
      expect(chef_run).to create_remote_file('/usr/bin/ignited')
        .with(source: 'https://github.com/weaveworks/ignite/releases/download/0.6.3/ignited-amd64')
    end
    it 'notifies ignite_service[ignited] to run immediately' do
      expect(chef_run.remote_file('/usr/bin/ignited')).to
      notify('ignite_service[ignited]').to(:restart).immediately
    end
  end
end
