module IgniteCookbook
  class IgniteServiceManagerSystemd < IgniteServiceBase
    resource_name :ignite_service_manager_systemd

    default_action :start

    provides :ignite_service_manager, os: 'linux' do |_node|
      Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
    end

    action :start do
      create_ignite_wait_ready

      # stock systemd socket file
      template "/lib/systemd/system/#{ignite_name}.socket" do
        source 'systemd/ignite.socket.erb'
        cookbook 'ignite'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          config: new_resource,
          ignite_name: ignite_name
        )
        not_if { ignite_name == 'default' && ::File.exist?('/lib/systemd/system/ignite.socket') }
      end

      # stock systemd unit file
      template "/lib/systemd/system/#{ignite_name}.service" do
        source 'systemd/ignite.service.erb'
        cookbook 'ignite'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          ignite_name: ignite_name,
          ignite_daemon_cmd: ignite_daemon_cmd
        )
        not_if { ignite_name == 'default' && ::File.exist?('/lib/systemd/system/ignite.service') }
      end

      # this overrides the main systemd socket
      template "/etc/systemd/system/#{ignite_name}.socket" do
        source 'systemd/ignite.socket-override.erb'
        cookbook 'ignite'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          config: new_resource,
          ignite_name: ignite_name,
          systemd_socket_args: systemd_socket_args
        )
      end

      # this overrides the main systemd service
      template "/etc/systemd/system/#{ignite_name}.service" do
        source 'systemd/ignite.service-override.erb'
        cookbook 'ignite'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          config: new_resource,
          ignite_name: ignite_name,
          ignite_daemon_cmd: ignite_daemon_cmd,
          systemd_args: systemd_args,
          ignite_wait_ready: "#{libexec_dir}/#{ignite_name}-wait-ready",
          env_vars: new_resource.env_vars
        )
        notifies :run, 'execute[systemctl daemon-reload]', :immediately
        notifies :run, "execute[systemctl try-restart #{ignite_name}]", :immediately
      end

      # avoid 'Unit file changed on disk' warning
      execute 'systemctl daemon-reload' do
        command '/bin/systemctl daemon-reload'
        action :nothing
      end

      # restart if changes in template resources
      execute "systemctl try-restart #{ignite_name}" do
        command "/bin/systemctl try-restart #{ignite_name}"
        action :nothing
      end

      # service management resource
      service ignite_name do
        provider Chef::Provider::Service::Systemd
        supports status: true
        action [:enable, :start]
        only_if { ::File.exist?("/lib/systemd/system/#{ignite_name}.service") }
        retries 1
      end
    end

    action :stop do
      # service management resource
      service ignite_name do
        provider Chef::Provider::Service::Systemd
        supports status: true
        action [:disable, :stop]
        only_if { ::File.exist?("/lib/systemd/system/#{ignite_name}.service") }
      end
    end

    action :restart do
      action_stop
      action_start
    end

  end
end
