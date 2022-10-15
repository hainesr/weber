# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

module WeBER
  module Adapters
    @adapters = {}

    def self.register_adapter(clazz, *schemes)
      schemes.each do |scheme|
        @adapters[scheme] = clazz
      end
    end

    def self.adapter_for_uri(uri)
      @adapters[uri.scheme.to_sym]
    end
  end
end

require_relative 'adapters/all'
