# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

# Chef recipe named 'smoke'
#
# Ignite Host requirements
#
# Source
# https://ignite.readthedocs.io/en/stable/dependencies.html
#
unless os.windows?
  describe user('root'), :skip do
    it { should exist }
  end
end

describe command('grep loop /lib/modules/`uname -r`/modules.builtin') do
  its('stdout') { should eq "kernel/drivers/block/loop.ko\n" }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

describe kernel_module('br_netfilter') do
  it { should be_loaded }
end

describe kernel_parameter('net.ipv6.conf.all.forwarding') do
  its('value') { should eq 1 }
end

describe kernel_parameter('net.ipv4.ip_forward') do
  its('value') { should eq 1 }
end

describe kernel_parameter('net.bridge.bridge-nf-call-iptables') do
  its('value') { should eq 0 }
end

kernel_env_vars = %w( CONFIG_VIRTIO_BLK
                      CONFIG_VIRTIO_NET
                      CONFIG_KEYBOARD_ATKBD
                      CONFIG_SERIO_I8042 )

kernel_env_vars.each do |e|
  describe os_env(e, 'system') do
    its('content') { should eq 'y' }
  end
end

describe command('ignite images') do
  its(:exit_status) { should_not eq 0 }
  its(:stdout) { should_not match(/weaveworks\/ignite-ubuntu:latest/) }
  its(:stdout) { should_not match(/1\.2 GB/) }
  its(:stdout) { should_not match(/456\.0 MB/) }
  its(:stdout) { should_not match(/ubuntu/) }
end

describe command('ignite ps --all') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/weaveworks\/ignite-kernel:4.19.47/) }
  its(:stdout) { should_not match(/rpfrdqxmffadvn6t/) }
  its(:stdout) { should_not match(/1\.2 GB/) }
  its(:stdout) { should_not match(/456\.0 MB/) }
end

describe command('ignite images ls') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/weaveworks\/ignite-ubuntu:latest/) }
  its(:stdout) { should_not match(/1\.2 GB/) }
end
