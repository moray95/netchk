# frozen_string_literal: true

class Hash
  def symbolize_keys
    map do |key, value|
      value = if value.is_a?(Hash)
                value.symbolize_keys
              else
                value
              end
      [key.to_sym, value]
    end.to_h
  end
end
