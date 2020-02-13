# Constants
IPV6_ADDR ||= /(
([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|
([0-9a-fA-F]{1,4}:){1,7}:|
([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|
([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|
([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|
([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|
([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|
[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|
:((:[0-9a-fA-F]{1,4}){1,7}|:)|
fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|
::(ffff(:0{1,4}){0,1}:){0,1}
((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}
(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|
([0-9a-fA-F]{1,4}:){1,4}:
((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}
(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])
)/.freeze

IPV4_ADDR ||= /((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])/.freeze

IPV6_CIDR ||= /s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:)))(%.+)?s*/.freeze

IPV4_CIDR ||= %r{(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))}.freeze

module IgniteCookbook
  module IgniteHelpers
    module Service
      #######################
      # Common Helper Methods
      #######################
      require_relative 'helpers_common'
      include IgniteHelpers::Common

      #########################
      # Action helper methods
      #########################

      def installed_ignite_version
        o = shell_out("#{ignite_bin} version")
        o.stdout.split[2].chomp(',')
      end

      def installed_ignited_version
        o = shell_out("#{ignite_bin} version")
        o.stdout.split[2].chomp(',')
      end

      def connect_host
        return nil unless host
        sorted = coerce_host(host).sort do |a, b|
          c_a = 1 if a =~ /^unix:/
          c_a = 2 if a =~ /^fd:/
          c_a = 3 if a =~ %r{^tcp://127.0.0.1:}
          c_a = 4 if a =~ %r{^tcp://(192\.168|10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.).*:}
          c_a = 5 if a =~ %r{^tcp://0.0.0.0:}
          c_a ||= 6
          c_b = 1 if b =~ /^unix:/
          c_b = 2 if b =~ /^fd:/
          c_b = 3 if b =~ %r{^tcp://127.0.0.1:}
          c_b = 4 if b =~ %r{^tcp://(192\.168|10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.).*:}
          c_b = 5 if b =~ %r{^tcp://0.0.0.0:}
          c_b ||= 6
          c_a <=> c_b
        end
        if sorted.first =~ %r{^tcp://0.0.0.0:}
          r = sorted.first.match(%r{(?<proto>.*)://(?<socket>[^:]+):?(?<port>\d+)?})
          return "tcp://127.0.0.1:#{r['port']}"
        end
        sorted.first
      end

      def connect_socket
        return "/var/run/#{ignite_name}.sock" unless host
        return nil if host.grep(%r{unix://|fd://}).empty?
        sorted = coerce_host(host).sort do |a, b|
          c_a = 1 if a =~ /^unix:/
          c_a = 2 if a =~ /^fd:/
          c_a ||= 3
          c_b = 1 if b =~ /^unix:/
          c_b = 2 if b =~ /^fd:/
          c_b ||= 3
          c_a <=> c_b
        end
        sorted.first.sub(%r{unix://|fd://}, '')
      end

      def coerce_host(v)
        v = v.split if v.is_a?(String)
        Array(v).each_with_object([]) do |s, r|
          if s.match(/^unix:/) || s.match(/^tcp:/) || s.match(/^fd:/)
            r << s
          else
            Chef::Log.info("WARNING: ignite_service host property #{s} not valid")
          end
        end
      end

      def coerce_daemon_labels(v)
        Array(v).each_with_object([]) do |label, a|
          if label =~ /:/
            parts = label.split(':')
            a << "#{parts[0]}=\"#{parts[1]}\""
          elsif label =~ /=/
            parts = label.split('=')
            a << "#{parts[0]}=#{parts[1]}"
          else
            Chef::Log.info("WARNING: ignite_service label #{label} not valid")
          end
        end
      end

      def coerce_insecure_registry(v)
        case v
        when Array, nil
          v
        else
          Array(v)
        end
      end

      def containerd_daemon_opts
        ['--containerd=/run/containerd/containerd.sock'].join(' ')
      end

      def ignited_major_version
        ray = ignite_url_version(ignite_uri).split('.')
        ray[0][0] = ''
        ray.pop
        ray.push.join('.')
      end

      def ignite_daemon_arg
        if Gem::Version.new(ignited_major_version) < Gem::Version.new('0.6')
          'daemon'
        else
          'daemon'
        end
      end

      def ignite_raw_logs_arg
        if Gem::Version.new(ignited_major_version) < Gem::Version.new('0.6')
          ''
        else
          '--output "short"'
        end
      end

      def ignite_daemon_cmd
        [ignited_bin, ignite_daemon_arg, ignite_daemon_opts].join(' ')
      end

      def ignite_cmd
        [ignite_bin, ignite_opts].join(' ')
      end

      def ignite_opts
        opts = []
        opts
      end

      def systemd_args
        opts = ''
        systemd_opts.each { |systemd_opt| opts << "#{systemd_opt}\n" } if systemd_opts
        opts
      end

      def systemd_socket_args
        opts = ''
        systemd_socket_opts.each { |systemd_socket_opt| opts << "#{systemd_socket_opt}\n" } if systemd_socket_opts
        opts
      end

      def ignite_daemon_opts
        opts = []
        opts << "--network-plugin #{network_plugin}" if network_plugin
        opts << "--runtime #{runtime}" if runtime
        opts << "--log-level #{log_level}" if log_level
        opts << misc_opts if misc_opts
        opts
      end

      def ignite_running?
        o = shell_out("#{ignite_cmd} ps | head -n 1 | grep ^CONTAINER")
        return true if o.stdout =~ /CONTAINER/
        false
      end
    end unless defined?(IgniteCookbook::IgniteHelpers::Service)
  end
end
