# SPDX-License-Identifier: Apache-2.0
# Copyright:: (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

module IgniteCookbook
  class IgniteServiceManagerSysvinitRhel < IgniteServiceBase
    resource_name :ignite_service_manager_sysvinit_rhel

    provides :ignite_service_manager, platform: 'amazon'
    provides :ignite_service_manager, platform: 'suse'
    provides :ignite_service_manager, platform_family: 'rhel' do |node|
      node['platform_version'].to_f <= 7.0
    end

    provides :ignite_service_manager_sysvinit, platform: 'amazon'
    provides :ignite_service_manager_sysvinit, platform: 'suse'
    provides :ignite_service_manager_sysvinit, platform_family: 'rhel' do |node|
      node['platform_version'].to_f <= 7.0
    end

    action :start do
      create_ignite_wait_ready
      create_init
      create_service
    end

    action :stop do
      create_init
      s = create_service
      s.action :stop
    end

    action :restart do
      action_stop
      action_start
    end

    action_class.class_eval do
      def create_init
        execute 'groupadd ignite' do
          not_if 'getent group ignite'
          action :run
        end

        link ignited_bin_link do
          to ignited_bin
          link_type :hard
        end

        template "/etc/init.d/#{ignite_name}" do
          cookbook 'ignite'
          source 'sysvinit/ignite-rhel.erb'
          owner 'root'
          group 'root'
          mode '0755'
          variables(
            ignite_name:       ignite_name,
            ignited_bin_link:  ignited_bin_link,
            ignite_daemon_cmd: ignite_daemon_cmd,
            ignite_wait_ready: "#{libexec_dir}/#{ignite_name}-wait-ready"
          )
          notifies :restart, "service[#{ignite_name}]", :immediately
        end

        template "/etc/sysconfig/#{ignite_name}" do
          cookbook 'ignite'
          source 'sysconfig/ignite.erb'
          owner 'root'
          group 'root'
          mode '0644'
          variables(config: new_resource)
          notifies :restart, "service[#{ignite_name}]", :immediately
        end
      end

      def create_service
        service ignite_name do
          supports restart: true, status: true
          action [:enable, :start]
        end
      end
    end
  end
end
