
module IgniteCookbook
  class IgniteServiceManagerSysvinitDebian < IgniteServiceBase
    resource_name :ignite_service_manager_sysvinit_debian

    provides :ignite_service_manager, platform: 'debian' do |node|
      node['platform_version'].to_f < 8.0
    end

    provides :ignite_service_manager_sysvinit, platform: 'debian' do |node|
      node['platform_version'].to_f < 8.0
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
          action :create
        end

        template "/etc/init.d/#{ignite_name}" do
          source 'sysvinit/ignite-debian.erb'
          cookbook 'ignite'
          owner 'root'
          group 'root'
          mode '0755'
          variables(
            ignite_name:        ignite_name,
            ignited_bin_link:   ignited_bin_link,
            ignite_daemon_arg:  ignite_daemon_arg,
            ignite_daemon_opts: ignite_daemon_opts.join(' '),
            ignite_wait_ready:  "#{libexec_dir}/#{ignite_name}-wait-ready"
          )
          action :create
        end

        template "/etc/default/#{ignite_name}" do
          source 'default/ignite.erb'
          cookbook 'ignite'
          variables(config: new_resource)
          action :create
        end
      end

      def create_service
        service ignite_name do
          provider Chef::Provider::Service::Init::Debian
          supports restart: true, status: true
          action [:enable, :start]
        end
      end
    end
  end
end
