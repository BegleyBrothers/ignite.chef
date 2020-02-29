# SPDX-License-Identifier: Apache-2.0
# Copyright:: (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

# Where to find external cookbooks:
default_source :supermarket, 'https://supermarket.chef.io/'
default_source :chef_repo,   './../test/cookbooks'

cookbook 'ignite', path: './../'
