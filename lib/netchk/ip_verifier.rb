# frozen_string_literal: true
require 'socket'

module Netchk
  class IpVerifier
    def verify
      socket = Socket.ip_address_list
      addresses = socket.reject(&:ipv4_loopback?)
                    .reject(&:ipv6_loopback?)
                    .filter(&:ipv4?)
                    .map(&:inspect_sockaddr)

      if addresses.empty?
        $stderr.puts "No IPv4 address found. Verify your connection to your router."
      else
        puts "Found IP addresses #{addresses.join(', ')}."
      end
    end
  end
end
