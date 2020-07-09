# frozen_string_literal: true
require 'netchk/ext/hash'
require 'forwardable'

class Config
  attr_reader :options

  def initialize(options)
    @options = options.symbolize_keys
  end

  def ==(other)
    return false unless other.is_a?(Config)
    other.options == options
  end

  private
    def method_missing(symbol, *args)
      raise ArgumentError, "wrong number of arguments (given #{args.count}, expected 0)" if args.count > 0

      @options[symbol] || {}
    end
end
