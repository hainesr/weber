# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'adapters'
require_relative 'token'
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
      tokens = []
      buf = +''
      in_tag = false

      html.each_char do |c|
        case c
        when '<'
          in_tag = true
          tokens << Token.text(buf) unless buf.empty?
          buf = +''
        when '>'
          in_tag = false
          tokens << Token.tag(buf)
          buf = +''
        else
          buf << c
        end
      end

      tokens << Token.text(buf) unless in_tag || buf.empty?
      tokens
    end
  end
end
