module IgniteCookbook
  require_relative 'ignite_service_base'

  class IgniteService < IgniteServiceBase
    resource_name :ignite_service

    # register with the resource resolution system
    provides :ignite_service

    # installation type and service_manager
    property :install_method, %w(binary package tarball none auto), default: 'binary', desired_state: false
    property :service_manager, %w(execute sysvinit upstart systemd auto), default: 'auto', desired_state: false

    # ignited_installation_binary
    property :uri, String, default: lazy{ default_uri }, desired_state: false
    property :ignited_bin, String, desired_state: false

    # ignite_installation_tarball
    property :checksum, String, desired_state: false
    property :ignited_bin, String, desired_state: false
    property :source, String, desired_state: false

    # ignite_installation_package
    property :package_version, String, desired_state: false
    property :package_name, String, desired_state: false
    property :setup_ignite_repo, [true, false], desired_state: false

    # package and tarball
    property :version, String, desired_state: false
    property :package_options, String, desired_state: false

    ################
    # Helper Methods
    ################
    def copy_properties_to(to, *properties)
      properties = self.class.properties.keys if properties.empty?
      properties.each do |p|
        # If the property is set on from, and exists on to, set the
        # property on to
        if to.class.properties.include?(p) && property_is_set?(p)
          to.send(p, send(p))
        end
      end
    end

    action_class.class_eval do
      def validate_install_method
        if new_resource.property_is_set?(:version) &&
           new_resource.install_method != 'package' &&
           new_resource.install_method != 'tarball'
          raise Chef::Exceptions::ValidationFailed, 'Version property only supported for package and tarball installation methods'
        end
      end

      def installation(&block)
        case new_resource.install_method
        when 'auto'
          install = ignite_installation(new_resource.name, &block)
        when 'script'
          install = ignite_installation_script(new_resource.name, &block)
        when 'package'
          install = ignite_installation_package(new_resource.name, &block)
        when 'tarball'
          install = ignite_installation_tarball(new_resource.name, &block)
        when 'binary'
          install = ignited_installation_binary(new_resource.name, &block)
        when 'none'
          Chef::Log.info('Skipping Ignite installation. Assuming it was handled previously.')
          return
        end
        copy_properties_to(install)
        install
      end

      def svc_manager(&block)
        case new_resource.service_manager
        when 'auto'
          svc = ignite_service_manager(new_resource.name, &block)
        when 'execute'
          svc = ignite_service_manager_execute(new_resource.name, &block)
        when 'sysvinit'
          svc = ignite_service_manager_sysvinit(new_resource.name, &block)
        when 'upstart'
          svc = ignite_service_manager_upstart(new_resource.name, &block)
        when 'systemd'
          svc = ignite_service_manager_systemd(new_resource.name, &block)
        end
        copy_properties_to(svc)
        svc
      end
    end

    #########
    # Actions
    #########

    action :create do
      validate_install_method

      installation do
        action :install
        notifies :restart, new_resource, :immediately
      end
    end

    action :delete do
      installation do
        action :delete
      end
    end

    action :start do
      svc_manager do
        action :start
      end
    end

    action :stop do
      svc_manager do
        action :stop
      end
    end

    action :restart do
      svc_manager do
        action :restart
      end
    end
  end
end
