# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

service 'ignited' do
  action :enable
end

service 'with_attributes' do
  pattern 'ignite*'
  action :enable
end

service 'specifying the identity attribute' do
  service_name 'ignited'
  action :enable
end
