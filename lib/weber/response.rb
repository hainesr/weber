# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'util'

module WeBER
  class Response
    attr_reader :body, :headers, :status

    def initialize(status: nil, headers: {}, body: '')
      @status = status
      @headers = headers
      @body = body
    end

    def self.from_http(response)
      status, headers, body = Util.parse_http_response(response)
      new(status: status, headers: headers, body: body)
    end

    def client_error?
      @status < 500 && @status >= 400
    end

    def error?
      client_error? || server_error?
    end

    def informational?
      @status < 200
    end

    def redirect?
      @status < 400 && @status >= 300
    end

    def server_error?
      @status < 600 && @status >= 500
    end

    def success?
      @status < 300 && @status >= 200
    end
  end
end
