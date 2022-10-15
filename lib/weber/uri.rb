# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

module WeBER
  class URI
    attr_reader :data, :host, :media_type, :path, :port, :scheme

    def initialize(uri)
      @scheme, rest = uri.split(':', 2)
      if @scheme == 'data'
        @media_type, @data = rest.split(',', 2)
      else
        host, path = rest.delete_prefix('//').split('/', 2)
        @host, port = host.split(':')
        @path = "/#{path}"
        @port = port&.to_i
      end
    end
  end
end
