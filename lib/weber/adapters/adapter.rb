# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

module WeBER
  module Adapters
    class Adapter
      def initialize(io)
        @io = io
      end

      def self.request(uri)
        connection = new(uri)
        response = connection.get
        connection.close

        response
      end

      def close
        return if @io.nil?

        @io.close unless @io.closed?
      end
    end
  end
end
