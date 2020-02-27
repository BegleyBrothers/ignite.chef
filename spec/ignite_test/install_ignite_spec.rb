require 'spec_helper'

describe 'ignite_test::install_binary' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(platform:  'ubuntu',
                             version:   '18.04',
                             step_into: ['ignite_binary']).converge(described_recipe)
  end

  context 'testing default action, default properties' do
    it 'installs ignite' do
      expect(chef_run).to install_ignite_binary('default')
    end
    it 'installs a remote file' do
      expect(chef_run).to create_remote_file('/usr/bin/ignite')
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
                               step_into: ['ignite_binary'])
                          .converge(described_recipe)
    end

    it 'resolves URI to ignite binary file URL.' do
      expect(chef_run).to create_remote_file('/usr/bin/ignite')
        .with(source: 'https://github.com/weaveworks/ignite/releases/download/0.6.3/ignite-amd64')
    end
  end
end
