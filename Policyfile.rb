# SPDX-License-Identifier: Apache 2.0che 2.0
# Copyright:: 2020, Begley Brothers.
#
# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'ignite'

# Where to find external cookbooks:
default_source :supermarket

# Specify a custom source for a single cookbook:
cookbook 'ignite', path: '.'

# run_list: chef-client will run these recipes in the order specified.
run_list 'ignite::default'
