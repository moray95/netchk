# frozen_string_literal: true
require_relative 'icmp'
require 'net/ping/icmp'

class Array
  def avg
    reduce(:+) / count
  end
end

module Netchk
  class ICMPPingVerifier
    def initialize(**options)
      @hosts = options['hosts'] || %w[1.1.1.1 8.8.8.8]
      @count = options['count'] || 20
      @interval = options['interval'] || 0.2
    end

    def verify
      stats = @hosts.map do |host|
        host_stats = ping(host, @count)

        average = host_stats[:durations].empty? ? 'N/A' : (host_stats[:durations].avg * 1000).round(2)
        errors = host_stats[:failures].to_f / (host_stats[:failures] + host_stats[:durations].count) * 100
        puts "Stats for #{host} ping - average: #{average} ms, error rate: #{errors.round(2)}%"

        [host, host_stats]
      end.to_h

      all_durations = stats.values.flat_map { |host_stats| host_stats[:durations] }
      overall_average = all_durations.empty? ? 'N/A' : (all_durations.avg * 1000).round(2)
      overall_errors = stats.values.flat_map { |host_stats| host_stats[:failures].to_f / host_stats[:count] * 100 }.avg
      puts "Overall stats for ping - average: #{overall_average} ms, error rate: #{overall_errors.round(2)}%"
    end

    private
      def ping(host, count)
        stats = {
          durations: [],
          failures: 0,
          count: count
        }

        pingClass = /darwin/.match?(RUBY_PLATFORM) ? ::Netchk::ICMP : ::Net::Ping::ICMP
        ping = pingClass.new(host, nil, 1)

        count.times do
          sleep @interval
          if ping.ping
            stats[:durations] << ping.duration
          else
            $stderr.puts "pinging #{host} failed: #{ping.exception || "Unknown error"}"
            stats[:failures] += 1
          end
        end

        stats
      end
  end
end
