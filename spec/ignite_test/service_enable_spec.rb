# SPDX-License-Identifier: Apache-2.0
# Copyright:: (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

describe 'ignite_test::service_enable' do
  platform 'ubuntu'

  describe 'enables a service with an explicit action' do
    it { is_expected.to enable_service('ignited') }
    it { is_expected.to_not enable_service('not_explicit_action') }
  end

  describe 'enables a service with attributes' do
    it { is_expected.to enable_service('with_attributes').with(pattern: 'ignite*') }
    it { is_expected.to_not enable_service('with_attributes').with(pattern: 'bacon') }
  end

  describe 'enables a service when specifying the identity attribute' do
    it { is_expected.to enable_service('specifying the identity attribute') }
  end
end
