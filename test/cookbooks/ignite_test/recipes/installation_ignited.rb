# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

# ignite_service 'default'

ignited_installation_binary 'default' do
  uri node['ignite']['uri']
  action :install
end
