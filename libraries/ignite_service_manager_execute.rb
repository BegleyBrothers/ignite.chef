# SPDX-License-Identifier: Apache-2.0
# Copyright:: (c) 2020 Begley Brothers Inc.
#
# See details in LICENSE.

module IgniteCookbook
  class IgniteServiceManagerExecute < IgniteServiceBase
    resource_name :ignite_service_manager_execute

    # Start the service
    action :start do
      # enable ipv4 forwarding
      execute 'enable net.ipv4.conf.all.forwarding' do
        command '/sbin/sysctl net.ipv4.conf.all.forwarding=1'
        not_if '/sbin/sysctl -q -n net.ipv4.conf.all.forwarding | grep ^1$'
        action :run
      end

      # enable ipv6 forwarding
      execute 'enable net.ipv6.conf.all.forwarding' do
        command '/sbin/sysctl net.ipv6.conf.all.forwarding=1'
        not_if '/sbin/sysctl -q -n net.ipv6.conf.all.forwarding | grep ^1$'
        action :run
      end

      # Go doesn't support detaching processes natively, so we have
      # to manually fork it from the shell with &
      bash "start ignite #{name}" do
        code "#{ignite_daemon_cmd} >> #{logfile} 2>&1 &"
        environment 'HTTP_PROXY'  => http_proxy,
                    'HTTPS_PROXY' => https_proxy,
                    'NO_PROXY'    => no_proxy,
                    'TMPDIR'      => tmpdir
        not_if "ps -ef | grep -v grep | grep #{Shellwords.escape(ignite_daemon_cmd)}"
        action :run
      end

      create_ignite_wait_ready

      execute 'ignite-wait-ready' do
        command "#{libexec_dir}/#{ignite_name}-wait-ready"
      end
    end

    action :stop do
      execute "stop ignite #{name}" do
        command "kill `cat #{pidfile}` && while [ -e #{pidfile} ]; do sleep 1; done"
        timeout 10
        only_if "#{ignite_cmd} ps | head -n 1 | grep ^CONTAINER"
      end
    end

    action :restart do
      action_stop
      action_start
    end
  end
end
