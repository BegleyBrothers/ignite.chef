module IgniteCookbook
  class IgnitedInstallBinary < IgniteBase
    ################
    # Helper Methods
    ################
    require_relative 'helpers_install'

    include ::IgniteCookbook::IgniteHelpers::Install

    resource_name :ignited_binary

    provides :ignited_installation_binary, os: 'linux'

    property  :uri, String,
              default: lazy { default_uri },
              desired_state: false,
              description: 'Constrain URL construction to Ignite URIs.'
    property  :install_docker, [true, false],
              default: false,
              description: 'Install Docker service. Warning: Docker support is deprecated, and will be removed in a future release.'
    property  :serio_i8042, String,
              default: 'y',
              description: 'Serial IO device. Optional but recommended.'
    property  :keyboard_atkbd, String,
              default: 'y',
              description: 'Keyboard device. Optional but recommended.'

    default_action :install

    ##################
    # Property Helpers
    ##################

    #########
    # Actions
    #########

    action_class do
      include ::IgniteCookbook::IgniteHelpers::Install
    end

    action :install do
      setup_host
      
      bash 'Install CNI plugins' do
        code <<-EOH
        CNI_VERSION=v0.8.2
        export ARCH=$([ $(uname -m) = 'x86_64' ] && echo amd64 || echo arm64)
        mkdir -p /opt/cni/bin
        curl -sSL https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz | tar -xz -C /opt/cni/bin
        EOH
        not_if { ::File.exist?('/opt/cni/bin/bridge') }
      end

      # some other stuff here
      ignt_file = remote_file ignited_bin do
        source build_ignite_url(ignite_uri)
        mode '00755'
        action :create
        #notifies :restart, "ignite_service[#{ignited_name}]", :immediately
      end
      #ignt_file.run_action(:create)
      #new_resource.updated_by_last_action(true) if ignt_file.updated_by_last_action?
    end

    action :uninstall do
      # Force-remove all running VMs only if ignite is installed.
      execute 'ignite rm -f $(ignite ps -aq)' do
        only_if { ::File.exist?(ignite_bin) }
      end
      # Remove the data directory
      directory '/var/lib/firecracker' do
        action :delete
        recursive true
      end
      # Remove the ignited binaries
      file ignited_bin do
        action :delete
      end
      docker_installation 'ignite' do
        action :delete
        only_if '[ ! -z `docker info` ]'
      end
    end
  end
end
