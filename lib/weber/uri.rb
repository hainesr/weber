# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

module WeBER
  class URI
    attr_reader :host, :path, :port, :scheme

    def initialize(uri)
      @scheme, rest = uri.split('://')
      host, path = rest.split('/', 2)
      @host, port = host.split(':')
      @path = "/#{path}"
      @port = port&.to_i
    end
  end
end
