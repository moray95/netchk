# frozen_string_literal: true
require 'socket'

module Netchk
  class IpVerifier
    def initialize(out: $stdout, err: $stderr)
      @out = out
      @err = err
    end

    def verify
      socket = Socket.ip_address_list
      addresses = socket.reject(&:ipv4_loopback?)
      addresses.reject!(&:ipv6_loopback?)
      addresses.select!(&:ipv4?)
      addresses.map!(&:inspect_sockaddr)

      if addresses.empty?
        @err.puts 'No IPv4 address found. Verify your connection to your router.'
      else
        @out.puts "Found IP addresses #{addresses.join(', ')}."
      end
    end
  end
end
