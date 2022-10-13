# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require 'openssl'
require 'socket'
require 'stringio'

require_relative 'uri'
require_relative 'util'

module WeBER
  class Connection
    def initialize(host, port: nil, ssl: false)
      port ||= (ssl ? 443 : 80)
      @host = host
      @ssl = ssl

      @socket = create_socket(port)
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

    def ssl?
      @ssl
    end

    private

    def create_socket(port)
      tcp = TCPSocket.open(@host, port)
      return tcp unless ssl?

      context = OpenSSL::SSL::SSLContext.new
      context.verify_mode = OpenSSL::SSL::VERIFY_NONE

      socket = OpenSSL::SSL::SSLSocket.new(tcp, context)
      socket.connect

      socket
    end

    def request(method, path)
      request_string =
        case method
        when :get
          "GET #{path} HTTP/1.0\r\nHost: #{@host}\r\n\r\n"
        end

      @socket.syswrite(request_string)

      response = StringIO.new
      loop do
        response << @socket.sysread(512)
      rescue EOFError
        break
      end

      response.rewind
      Util.parse_response(response)
    end
  end
end
