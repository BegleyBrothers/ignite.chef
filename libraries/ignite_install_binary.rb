module IgniteCookbook
  class IgniteInstallBinary < IgniteBase
    ################
    # Helper Methods
    ################
    require_relative 'helpers_install'

    include IgniteHelpers::Install

    resource_name :ignite_binary

    provides :ignite_installation_binary, os: 'linux'

    property  :uri, String,
              default:       lazy { default_uri },
              desired_state: false,
              description:   'Constrain URL construction to Ignite URIs.'
    property  :install_docker, [true, false],
              default:     false,
              description: 'Install Docker service. Warning: Docker support is deprecated, and will be removed in a future release.'
    property  :serio_i8042, String,
              default:     'y',
              description: 'Serial IO device. Optional but recommended.'
    property  :keyboard_atkbd, String,
              default:     'y',
              description: 'Keyboard device. Optional but recommended.'

    default_action :install

    ##################
    # Property Helpers
    ##################

    def default_uri
      'ignt://weaveworks/?file=ignite&version=0.6.3#amd64'
    end

    #########
    # Actions
    #########

    action_class do
      include ::IgniteCookbook::IgniteHelpers::Install
    end

    action :install do
      setup_host

      bash 'Install CNI plugins' do
        code <<-HEREDOC
        export CNI_VERSION=v0.8.2
        export ARCH=$([ $(uname -m) = 'x86_64' ] && echo amd64 || echo arm64)
        mkdir -p /opt/cni/bin
        curl -sSL https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz | tar -xz -C /opt/cni/bin
        HEREDOC
        not_if { ::File.exist?('/opt/cni/bin/bridge') }
      end

      remote_file ignite_bin do
        source build_ignite_url(ignite_uri)
        mode '00755'
        action :create
      end
    end

    action :uninstall do
      # Force-remove all running VMs
      execute 'ignite rm -f $(ignite ps -aq)'
      # Remove the data directory
      directory '/var/lib/firecracker' do
        action :delete
        recursive true
      end
      # Remove the ignite binaries
      file ignite_bin do
        action :delete
      end
      docker_installation 'ignite' do
        action :delete
        only_if '[ ! -z `docker info` ]'
      end
    end
  end
end
