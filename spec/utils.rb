# frozen_string_literal: true
require 'socket'
require 'resolv'

DEFAULT_IP = Addrinfo.ip('192.168.128.1')
LOOPBACK_IP = Addrinfo.ip('127.0.0.1')
DEFAULT_DNS = %w[1.1.1.1 53]
DOMAIN = 'github.com'

class HashToIVar
  def initialize(hash)
    hash.each do |k, v|
      if v.is_a?(Hash)
        instance_variable_set("@#{k}", HashToIVar.new(v))
      else
        instance_variable_set("@#{k}", v)
      end
    end
  end
end

class Netchk::IpVerifier
  def self.mocked
    out = StringIO.new
    err = StringIO.new
    [out, err, new(out: out, err: err)]
  end
end

class Netchk::DNSVerifier
  def self.mocked
    out = StringIO.new
    err = StringIO.new
    [out, err, new(out: out, err: err)]
  end
end

class Netchk::ResolvVerifier
  def self.mocked(domains)
    out = StringIO.new
    err = StringIO.new
    [out, err, new(out: out, err: err, domains: domains)]
  end
end

class Netchk::ICMPVerifier
  def self.mocked(hosts, count)
    out = StringIO.new
    err = StringIO.new
    [out, err, new(out: out, err: err, hosts: hosts, count: count)]
  end
end

class Resolv::DNS
  def self.mocked(nameservers)
    dns = HashToIVar.new({
                           config: {
                             nameserver_port: nameservers
                           }
                         })

    def dns.lazy_initialize
    end
    dns
  end
end
