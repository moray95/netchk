# frozen_string_literal: true
module Netchk
  class DNSResolvVerifier
    def initialize(**options)
      @domains = options['domains'] || %w[google.com youtube.com facebook.com]
      @resolv_conf = options['resolv.conf']
    end

    def verify
      ::Resolv::DNS.open(@resolv_conf) do |dns|
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
