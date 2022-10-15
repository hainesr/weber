# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require 'openssl'
require 'socket'
require 'stringio'

require_relative 'adapter'
require_relative '../response'

module WeBER
  module Adapters
    class Socket < Adapter
      REQUEST_HEADERS = [
        'HTTP/1.1',
        'Host: %<host>s',
        'Connection: close',
        'User-Agent: Web Browser Engineering in Ruby (WeBER)'
      ].freeze

      def initialize(uri)
        @ssl = (uri.scheme == 'https')
        port = uri.port || (@ssl ? 443 : 80)
        @host = uri.host
        @path = uri.path

        super(create_socket(port))
      end

      def get
        request(:get)
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

      def request(method)
        request_string =
          case method
          when :get
            "GET #{@path} #{request_headers}\r\n\r\n"
          end

        @io.syswrite(request_string)

        response = StringIO.new
        loop do
          response << @io.sysread(512)
        rescue EOFError
          break
        end

        response.rewind
        Response.from_http(response)
      end

      def request_headers
        format(REQUEST_HEADERS.join("\r\n"), host: @host)
      end
    end
  end
end
