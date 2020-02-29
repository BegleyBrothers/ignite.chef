# SPDX-License-Identifier: Apache-2.0
# Copyright:: (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'ignite_kitchen'

# Pull in base policy.
instance_eval(IO.read(File.expand_path('../_base.rb', __FILE__)))

# run_list: chef-client will run these recipes in the order specified.
run_list 'ignite_test::installation_ignite'
