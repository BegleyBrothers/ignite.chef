
require 'spec_helper'
require_relative '../../libraries/helpers_service'

describe 'ignite_test::service' do
  before do
    stubs_for_resource('ignite_service_manager_systemd[ignited]') do |resource|
      allow(resource).to receive_shell_out('/usr/bin/ignite version', stdout: 'Ignite version 0.0.0, build 0ffa825')
    end
  end

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(platform:  'ubuntu',
                             version:   '18.04',
                             step_into: %w(helpers_service ignite_service ignite_service_base ignite_service_manager ignite_service_manager_systemd)).converge(described_recipe)
  end

  it 'creates service[ignite-ignited]' do
    # directory[/usr/lib/ignite]
    # /lib/systemd/system/ignite-ignited.socket
    # /lib/systemd/system/ignite-ignited.service
    # /etc/systemd/system/ignite-ignited.socket
    # /etc/systemd/system/ignite-ignited.service
    # execute[systemctl daemon-reload]
    # execute[systemctl try-restart ignite-ignited]
    # service[ignite-ignited]
    expect(chef_run).to create_directory('/usr/lib/ignite')
  end

  it { is_expected.to render_file('/usr/lib/ignite/ignite-ignited-wait-ready') }
  it { is_expected.to render_file('/lib/systemd/system/ignite-ignited.socket') }
  it { is_expected.to render_file('/lib/systemd/system/ignite-ignited.socket') }
  it { is_expected.to render_file('/lib/systemd/system/ignite-ignited.service') }
  it { is_expected.to render_file('/etc/systemd/system/ignite-ignited.socket') }
  it { is_expected.to render_file('/etc/systemd/system/ignite-ignited.service') }

  it 'expect execute ystemctl daemon-reload to be created' do
    ignt_rsrc = chef_run.execute('systemctl daemon-reload')
    expect(ignt_rsrc).to do_nothing
  end

  it 'expect execute systemctl try-restart ignite-ignited to be created' do
    ignt_rsrc = chef_run.execute('systemctl try-restart ignite-ignited')
    expect(ignt_rsrc).to do_nothing
  end

  it 'expect service ignite-ignited to do nothing' do
    ignt_rsrc = chef_run.service('ignite-ignited')
    expect(ignt_rsrc).to do_nothing
  end
end
