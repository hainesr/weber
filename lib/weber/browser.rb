# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'connection'

module WeBER
  class Browser
    def self.load(uri)
      status, headers, body = Connection.request(uri)
      show(body) if status == 200
    end

    def self.show(html)
      buf = +''
      in_tag = false

      html.each_char do |c|
        if c == '<'
          in_tag = true
        elsif c == '>'
          in_tag = false
        else
          buf << c unless in_tag
        end
      end

      buf
    end
  end
end
