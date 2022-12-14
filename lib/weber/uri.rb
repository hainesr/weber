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
      if uri.start_with?('data:')
        init_data(uri)
      elsif uri.include?('://')
        @scheme, rest = uri.split('://')
        host, path = rest.split('/', 2)
        @host, port = host.split(':')
        @path = "/#{path}"
        @port = port&.to_i
      else
        @path = uri
      end
    end

    def relative_path?
      !@path.start_with?('/')
    end

    def resolve_against(server)
      new_uri = dup
      new_uri.resolve_against!(server)

      new_uri
    end

    def resolve_against!(server)
      return unless @scheme.nil?

      @scheme = server.scheme
      @host = server.host
      @port = server.port
      @path = "/#{@path}" if relative_path?
    end

    private

    def init_data(uri)
      @scheme = 'data'
      @media_type, @data = uri[5..].split(',', 2)
    end
  end
end
