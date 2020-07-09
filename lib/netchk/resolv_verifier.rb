# frozen_string_literal: true
module Netchk
  class ResolvVerifier
    def initialize(out: $stdout, err: $stderr, **options)
      @out = out
      @err = err
      @domains = options[:domains] || %w[google.com youtube.com facebook.com]
      @resolv_conf = options[:'resolv.conf']
    end

    def verify
      ::Resolv::DNS.open(@resolv_conf) do |dns|
        @domains.each do |domain|
          begin
            dns.getaddress(domain)
            @out.puts "Resolved #{domain}"
          rescue ::Resolv::ResolvError
            @err.puts "Failed to resolve #{domain}"
          end
        end
      end
    end
  end
end
