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
    class Data < Adapter
      def initialize(uri)
        super(nil)
        @data = uri.data
      end

      def get
        Response.new(status: 200, body: @data)
      end
    end
  end
end
