# encoding: utf-8
# SPDX-License-Identifier: Apache-2.0
# Copyright:: (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

module IgniteCookbook
  class IgniteInspecBase < IgniteBase
    ################
    # Helper Methods
    ################
    require_relative 'helpers_inspec'

    include ::IgniteCookbook::IgniteHelpers::Inspec

    #####################
    # resource properties
    #####################

    resource_name :ignite_inspec_base

    # register with the resource resolution system
    provides :ignite_inspec_audit

    # Environment variables to ignite service
    property :attributes, Hash

    # daemon management
    property :instance, String, name_property: true, desired_state: false
    property :auto_restart, [true, false], default: false

    #########
    # Actions
    #########

    action_class do
      include ::IgniteCookbook::IgniteHelpers::Inspec
    end
  end unless defined?(IgniteCookbook::IgniteInspecBase)
end
