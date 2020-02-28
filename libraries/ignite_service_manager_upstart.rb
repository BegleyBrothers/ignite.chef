# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

module IgniteCookbook
  class IgniteServiceManagerUpstart < IgniteServiceBase
    resource_name :ignite_service_manager_upstart

    provides :ignite_service_manager, platform_family: 'debian' do |_node|
      Chef::Platform::ServiceHelpers.service_resource_providers.include?(:upstart) &&
        !Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
    end

    action :start do
      create_ignite_wait_ready

      link ignited_bin_link do
        to ignited_bin
        link_type :hard
        action :create
      end

      template "/etc/init/#{ignite_name}.conf" do
        source 'upstart/ignite.conf.erb'
        cookbook 'ignite'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          ignite_daemon_cmd:   [ignited_bin_link, ignite_daemon_arg, ignite_daemon_opts].join(' '),
          ignite_raw_logs_arg: ignite_raw_logs_arg,
          ignite_wait_ready:   "#{libexec_dir}/#{ignite_name}-wait-ready"
        )
        notifies :stop, "service[#{ignite_name}]", :immediately
        notifies :start, "service[#{ignite_name}]", :immediately
      end

      template "/etc/default/#{ignite_name}" do
        source 'default/ignite.erb'
        cookbook 'ignite'
        variables(config: new_resource)
        notifies :restart, "service[#{ignite_name}]", :immediately
      end

      service ignite_name do
        provider Chef::Provider::Service::Upstart
        supports status: true, restart: false
        action :start
      end
    end

    action :stop do
      service ignite_name do
        provider Chef::Provider::Service::Upstart
        supports status: true, restart: false
        action :stop
      end
    end

    action :restart do
      action_stop
      action_start
    end
  end
end
