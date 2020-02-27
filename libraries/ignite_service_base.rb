module IgniteCookbook
  class IgniteServiceBase < IgniteBase
    ################
    # Helper Methods
    ################
    require_relative 'helpers_service'

    include IgniteHelpers::Service

    #####################
    # resource properties
    #####################

    resource_name :ignite_service_base

    # register with the resource resolution system
    provides :ignite_service_manager

    # Environment variables to ignite service
    property :env_vars, Hash

    # daemon management
    property :instance, String, name_property: true, desired_state: false
    property :auto_restart, [true, false], default: false
    property :daemon, [true, false], default: true
    property :group, String, default: 'ignite'
    property :host, [String, Array], coerce: proc { |v| coerce_host(v) }, desired_state: false
    property :ip, [IPV4_ADDR, IPV6_ADDR, nil]
    property :ip_forward, [true, false]
    property :ipv4_forward, [true, false], default: true
    property :ipv6_forward, [true, false], default: true
    property :ip_masq, [true, false]
    property :iptables, [true, false]
    property :ipv6, [true, false]
    property :log_level, %w(debug info warn error fatal), default: 'debug'
    property :mount_flags, String, description: 'Used for MountFlags in systemd Ignite service file.'
    property :network_plugin, %w(cni docker-bridge), default: 'cni'
    property :runtime, %w(containerd docker), default: 'containerd'

    # These are options specific to systemd configuration such as
    # LimitNOFILE or TasksMax that you may wannt to use to customize
    # the environment in which Ignite runs.
    property :systemd_opts, [String, Array], coerce: proc { |v| v.nil? ? nil : Array(v) }
    property :systemd_socket_opts, [String, Array], coerce: proc { |v| v.nil? ? nil : Array(v) }

    # These are unvalidated daemon arguments passed in as a string.
    property :misc_opts, String

    # environment variables to set before running daemon
    property :http_proxy, String
    property :https_proxy, String
    property :no_proxy, String
    property :tmpdir, String

    # logging
    property :logfile, String, default: '/var/log/ignite-ignited-service.log'

    # ignite-wait-ready timeout
    property :service_timeout, Integer, default: 20

    alias_method :run_group, :group

    action_class do
      include ::IgniteCookbook::IgniteHelpers::Install
    end

    declare_action_class.class_eval do
      include ::IgniteCookbook::IgniteHelpers::Install

      def libexec_dir
        return '/usr/libexec/ignite' if node['platform_family'] == 'rhel'
        '/usr/lib/ignite'
      end

      def create_ignite_wait_ready
        directory libexec_dir do
          owner 'root'
          group 'root'
          mode '0755'
          action :create
        end

        template "#{libexec_dir}/#{ignite_name}-wait-ready" do
          source 'default/ignite-wait-ready.erb'
          owner 'root'
          group 'root'
          mode '0755'
          variables(
            ignite_cmd:      ignite_cmd,
            libexec_dir:     libexec_dir,
            service_timeout: new_resource.service_timeout
          )
          cookbook 'ignite'
          action :create
        end
      end
    end
  end
end
