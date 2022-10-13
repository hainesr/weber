# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

module WeBER
  module Util
    module_function

    def parse_response(response)
      status = parse_response_status(response.readline)

      headers = {}
      loop do
        line = response.readline
        break if line == "\r\n"

        header, value = line.split(':', 2)
        headers[header.downcase] = value.strip
      end

      [status, headers, response.read]
    end

    def parse_response_status(status_line)
      match = /HTTP.+(\d\d\d)/.match(status_line)
      match[1].to_i
    end
  end
end
