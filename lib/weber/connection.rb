# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require 'socket'
require 'stringio'

require_relative 'uri'
require_relative 'util'

module WeBER
  class Connection
    def initialize(host, port: nil, ssl: false)
      port ||= (ssl ? 433 : 80)
      @host = host

      @socket = TCPSocket.open(@host, port)
    end

    def self.request(uri)
      uri = URI.new(uri.to_s) unless uri.respond_to?(:scheme)

      connection = new(uri.host, port: uri.port, ssl: (uri.scheme == 'https'))
      response = connection.get(uri.path)
      connection.close

      response
    end

    def close
      @socket.close unless @socket.closed?
    end

    def get(path)
      request(:get, path)
    end

    private

    def request(method, path)
      request_string =
        case method
        when :get
          "GET #{path} HTTP/1.0\r\nHost: #{@host}\r\n\r\n"
        end

      @socket.send(request_string, 0)

      response = StringIO.new
      loop do
        data = @socket.recv(512)
        break if data.empty?

        response << data
      end

      response.rewind
      Util.parse_response(response)
    end
  end
end
