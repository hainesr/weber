# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'adapter'
require_relative '../response'

module WeBER
  module Adapters
    class File < Adapter
      def initialize(uri)
        file = ::File.file?(uri.path) ? ::File.new(uri.path) : nil
        super(file)
      end

      def get
        if @io.nil?
          Response.new(status: 404)
        else
          Response.new(status: 200, body: @io.read)
        end
      end
    end
  end
end
