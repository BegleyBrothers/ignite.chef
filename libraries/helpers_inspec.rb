
# encoding: utf-8
module IgniteCookbook
  module IgniteHelpers
    module Inspec

      def audit_settings(node)
        # Set the collector to chef-automate instead of the default chef-server-compliance.
        node.set['audit']['inspec_version'] = '1.2.1'

        node.set['audit']['collector'] = 'chef-automate'
        node.set['audit']['server'] = 'https://172.28.128.4:443/api/'
        node.set['audit']['token'] = 'token'
        node.set['audit']['owner'] = 'owner'
        node.set['audit']['quiet'] = nil
        node.set['audit']['refresh_token'] = nil
        # node.default['audit']['inspec_gem_source'] = 'http://internal.gem.server.com/gems'
        node.set['audit']['inspec_backend_cache'] = false
        node.set['audit']['interval']['enabled'] = true
        node.set['audit']['interval']['time'] = 1440 # once a day, the default value

        node.set['audit']['reporter'] = ['html', 'json-file']
        node.set['audit']['fetcher'] = 'chef-server'
        node
      end

      # audit_settings(node)
      # # Execute the community audit cookbook with the collector set
      # include_recipe 'audit::default'
    end unless defined?(::IgniteCookbook::IgniteHelpers::Inspec)
  end
end