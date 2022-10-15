# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'adapters'
require_relative 'uri'

module WeBER
  class Browser
    def self.load(uri)
      uri = URI.new(uri.to_s)
      connection = Adapters.adapter_for_uri(uri)
      response = connection.request(uri)
      show(response.body) if response.success?
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
