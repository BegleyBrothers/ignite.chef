# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

module IgniteCookbook
  module IgniteHelpers
    module Common
      #########################
      # Action helper methods
      #########################
      def default_uri
        'ignt://weaveworks/?file=ignited&version=0.6.3#amd64'
      end

      # parse the new_resource.uri property string
      #
      # @return [URI::Ignt] is the URI of the Ignite binary file
      def parse_ignite_uri
        uri = URI(new_resource.uri)
        if ignite_uri?(uri)
          uri
        else
          raise "Expected #{new_resource.uri} to have scheme ignt.  Example: ignt://weaveworks/?0.6.3#amd64"
        end
        uri
      end

      def ignite_uri
        @ignite_uri ||= parse_ignite_uri
      end

      def ignite_bin
        '/usr/bin/ignite'
      end

      def ignite_url_version(uri)
        "v#{::CGI.parse(uri.query)['version'][0]}"
      end

      def ignited_major_version
        ray = ignite_url_version(ignite_uri).split('.')
        ray[0][0] = ''
        ray.pop
        ray.push.join('.')
      end

      def ignited_bin
        return '/usr/bin/ignited' if Gem::Version.new(ignited_major_version) < Gem::Version.new('1.12')
        '/usr/bin/ignited'
      end

      def ignited_bin_link
        "/usr/bin/ignited-#{new_resource.name}"
      end

      def ignite_name
        return 'ignite' if new_resource.name == 'default'
        "ignite-#{new_resource.name}"
      end

      def ignited_name
        return 'ignited' if new_resource.name == 'default'
        "ignite-#{new_resource.name}"
      end
    end unless defined?(::IgniteCookbook::IgniteHelpers::Common)
  end
end
