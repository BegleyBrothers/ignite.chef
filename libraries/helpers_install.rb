module ::IgniteCookbook
  module IgniteHelpers
    module Install
      #######################
      # Common Helper Methods
      #######################
      require_relative 'helpers_common'
      include IgniteHelpers::Common

      #########################
      # Action helper methods
      #########################
      def setup_host
        setup_host_kernel
        setup_host_environment_variables
        setup_docker
        setup_packages
        setup_cni
      end

      def setup_host_kernel
        setup_host_kernel_modules
        setup_host_kernel_parameters
      end

      def setup_host_environment_variables
        append_if_no_line 'Set CONFIG_VIRTIO_BLK' do
          path '/etc/environment'
          line 'export CONFIG_VIRTIO_BLK=y'
        end
        append_if_no_line 'Set CONFIG_VIRTIO_NET' do
          path '/etc/environment'
          line 'export CONFIG_VIRTIO_NET=y'
        end
        append_if_no_line 'Set CONFIG_KEYBOARD_ATKBD' do
          path '/etc/environment'
          line "export CONFIG_KEYBOARD_ATKBD=#{new_resource.keyboard_atkbd}"
        end
        append_if_no_line 'Set CONFIG_SERIO_I8042' do
          path '/etc/environment'
          line "export CONFIG_SERIO_I8042=#{new_resource.serio_i8042}"
        end
      end

      def setup_host_kernel_modules
        # https://github.com/weaveworks/weave/issues/2789#issuecomment-433329349
        kernel_module 'br_netfilter'
      end

      # See: https://ignite.readthedocs.io/en/stable/dependencies.html
      def setup_host_kernel_parameters
        sysctl 'net.ipv6.conf.all.forwarding' do
          value 1
        end
        sysctl 'net.ipv4.ip_forward' do
          value 1
        end
        sysctl 'net.bridge.bridge-nf-call-iptables' do
          value 0
        end
      end

      def setup_docker
        if new_resource.install_docker
          install_docker
        else
          mimic_docker
        end
      end

      def install_docker
        setup_docker_repo
        setup_docker_package
      end

      # Mimic docker per Slack converstion:
      # https://weave-community.slack.com/archives/CL1A4S5UJ/p1580745314038700
      def mimic_docker
        file '/usr/bin/docker' do
          content 'echo mimic-docker'
          owner 'root'
          group 'root'
          mode '0755'
          action :create
        end
      end

      def setup_docker_repo
        case node['platform_family']
        when 'rhel', 'fedora'
          include_recipe 'chef-yum-docker'
        when 'debian', 'ubuntu'
          include_recipe 'chef-apt-docker'
        end
      end

      def setup_docker_package
        # Ignite installs default to using containerd & CNI rather than docker
        # Eventually this docker install must be removed from this resource.
        docker_installation_package 'ignite' do
          version node['docker']['version'] if node['docker'] && !node['docker']['version'].nil?
          action :create
          not_if '[ ! -z $(docker info) ]'
        end
      end

      def setup_packages
        case node['platform_family']
        when 'rhel', 'fedora'
          setup_rhel_packages
        when 'debian', 'ubuntu'
          setup_debian_packages
        end
      end

      def setup_debian_packages
        apt_update 'update'
        package %w(binutils dmsetup e2fsprogs git mount openssh-client tar jq wget)
        package 'containerd' do
          not_if { node['packages'].keys.include? 'containerd' }
        end
      end

      def setup_rhel_packages
        package %w(binutils device-mapper e2fsprogs git openssh-clients tar util-linux wget)
        package 'containerd.io' do
          not_if { node['packages'].keys.include? 'containerd.io' }
        end
      end

      def setup_cni
        cni_script = Tempfile.new('cni-install').path

        cookbook_file 'Create CNI install script' do
          source 'scripts/cni-install.sh'
          path cni_script
          mode '00755'
          cookbook 'ignite'
          not_if { ::File.exist?('/opt/cni/bin/bridge') }
        end

        execute 'CNI installation script' do
          command cni_script
          creates '/opt/cni/bin/bridge'
        end
      end
      # given a Ignite URI return a Ignite URL (https) for new_resource.filename.
      # @param [String] uri the Ignite file to be installed.
      #
      # @return [String] full HTTPS URL to the binary file `filename`
      def build_ignite_url(uri)
        # https://github.com/weaveworks/ignite/releases/download/v0.6.3/ignite-arm64"
        "https://#{ignite_url_host(uri)}#{ignite_url_path(uri)}#{ignite_url_version(uri)}/#{ignite_url_file(uri)}-#{ignite_url_arch(uri)}"
      end

      def ignite_url_file(uri)
        ::CGI.parse(uri.query)['file'][0]
      end

      def ignite_url_host(uri)
        case uri.host
        when 'weaveworks'
          'github.com'
        else
          uri.host
        end
      end

      def ignite_url_path(uri)
        case uri.host
        when 'weaveworks'
          '/weaveworks/ignite/releases/download/'
        else
          uri.path
        end
      end

      # determine if the repository URI is for Weaveworks
      # @param [String] url the url of the repository
      #
      # @return [Boolean] is the repo URL a PPA
      def ignite_uri?(uri)
        uri.scheme == 'ignt'
      end

      def architectures
        %w(amd64 arm64)
      end

      # determine the Ignite architecture:
      #  - "arch" property if defined
      #  - Ignite URI `fragment` value if "arch" not defined.
      #  - otherwise nothing
      #
      # @return [String] the Ignite binary architecture value.  One of amd64 or arm64.
      def ignite_url_arch(uri)
        arch = uri.fragment
        case arch
        when *architectures
          arch
        else
          raise "Expected #{new_resource.uri} to have as fragment one of: amd64 or arm64"
        end
      end
    end
  end
end
