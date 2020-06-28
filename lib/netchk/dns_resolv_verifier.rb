# frozen_string_literal: true
module Netchk
  class DNSResolvVerifier
    def initialize
      @domains = %w[google.com facebook.com]
    end

    def verify
      ::Resolv::DNS.open do |dns|
        @domains.each do |domain|
          begin
            dns.getaddress(domain)
          rescue ::Resolv::ResolvError
            $stderr.puts "Failed to resolve #{domain}"
          end
        end
      end
    end
  end
end
