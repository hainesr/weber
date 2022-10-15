# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'adapters'
require_relative 'uri'
require_relative 'window'

module WeBER
  class Browser
    def initialize
      @window = Window.new
    end

    def load(uri)
      uri = URI.new(uri.to_s)
      connection = Adapters.adapter_for_uri(uri)
      response = connection.request(uri)

      if response.success?
        @window.draw(lex(response.body))
      elsif response.redirect?
        new_uri = response.headers['location']
        load(new_uri)
      else
        "Status: #{response.status}"
      end
    end

    private

    def lex(html)
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
