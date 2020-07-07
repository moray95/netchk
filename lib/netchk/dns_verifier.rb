# frozen_string_literal: true
require 'resolv'
require 'socket'
require 'net/ping/tcp'

module Netchk
  class DNSVerifier
    def initialize(out: $stdout, err: $stderr, **options)
      @out = out
      @err = err
      @resolve_conf = options['resolv.conf']
    end

    def verify
      servers = nameservers
      if servers.empty?
        @err.puts 'No DNS server found. Verify your configuration.'
      else
        @out.puts "Using DNS servers #{servers.map { |ns| ns.join('#') }.join(', ')}"
        servers.map do |ns|
          verify_nameserver(*ns)
        end
      end
    end

    private
      def verify_nameserver(ip, port)
        ping = Net::Ping::TCP.new(ip, port)
        unless ping.ping?
          @err.puts "Failed to ping DNS server #{ip}##{port}"
        end
      end

      def nameservers
        # Dirty trick to get default nameserver list from /etc/resolv.conf
        # without parsing the file manually.
        ::Resolv::DNS.open(@resolve_conf) do |dns|
          dns.lazy_initialize
          dns.instance_variable_get('@config').instance_variable_get('@nameserver_port')
        end
      end
  end
end
