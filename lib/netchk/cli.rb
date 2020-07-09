# frozen_string_literal: true
require 'netchk/ip_verifier'
require 'netchk/dns_verifier'
require 'netchk/resolv_verifier'
require 'netchk/icmp_verifier'
require 'yaml'
require 'netchk/config'

module Netchk
  module CLI
    CONFIG_FILES = %w[.netchk.yaml .netchk.yml].map { |f| File.join(Dir.home, f) }

    def self.run
      pipeline(config).each(&:verify)
    end

    def self.config
      config_file = CONFIG_FILES.find(&File.method(:exists?))

      return Config.new({}) if config_file.nil?
      Config.new(YAML.safe_load(File.read(config_file)))
    end

    def self.pipeline(config)
      [
        Netchk::IpVerifier.new,
        Netchk::DNSVerifier.new(**config.dns),
        Netchk::ResolvVerifier.new(**config.resolv),
        Netchk::ICMPVerifier.new(**config.icmp)
      ]
    end
  end
end
