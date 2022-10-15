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
  end
end
