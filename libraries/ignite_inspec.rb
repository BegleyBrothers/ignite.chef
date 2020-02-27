module IgniteCookbook
  require_relative 'ignite_inspec_base'

  class IgniteInspec < IgniteInspecBase
    #######################
    # Common Helper Methods
    #######################
    require_relative 'helpers_common'
    include IgniteHelpers::Common

    resource_name :ignite_inspec

    # register with the resource resolution system
    provides :ignite_inspec

    # installation type and service_manager
    # property :install_method, %w(binary package tarball none auto), default: 'binary', desired_state: false
    # property :service_manager, %w(execute sysvinit upstart systemd auto), default: 'auto', desired_state: false

    # ignited_installation_binary
    property :uri, String, desired_state: false
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
    end

    #########
    # Actions
    #########

    action :create do
      audit_settings(node)

      include_recipe 'audit::default'
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
