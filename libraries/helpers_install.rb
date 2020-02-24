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

      def setup_docker
        setup_docker_repo
        setup_docker_package
      end

      def setup_docker_repo
        case node['platform_family']
        when 'rhel','fedora'
          include_recipe 'chef-yum-docker'
        when 'arch'
        when 'debian','ubuntu'
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
        when 'rhel','fedora'
          setup_rhel_packages
        when 'debian','ubuntu'
          setup_debian_packages
        end
      end

      def setup_debian_packages
        apt_update 'update'
        package %w(binutils dmsetup git openssh-client)
        package 'containerd' do
          not_if { node['packages'].keys.include? 'containerd' }
        end
      end

      def setup_rhel_packages
        package %w(e2fsprogs openssh-clients git)
        package 'containerd.io' do
          not_if { node['packages'].keys.include? 'containerd.io' }
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
      def is_ignite_uri?(uri)
        uri.scheme == 'ignt'
      end

      def architectures
        ['amd64','arm64']
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
