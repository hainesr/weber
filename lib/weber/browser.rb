# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'adapters'
require_relative 'html_parser'
require_relative 'uri'
require_relative 'gui'
require_relative 'gui/document_layout'

module WeBER
  class Browser
    def initialize
      @window = GUI::Window.new
    end

    def load(uri)
      uri = URI.new(uri.to_s)
      connection = Adapters.adapter_for_uri(uri)
      response = connection.request(uri)

      if response.success?
        doc_tree = HTMLParser.new(response.body).parse
        layout = GUI::DocumentLayout.new(doc_tree)
        @window.draw(layout)
      elsif response.redirect?
        new_uri = response.headers['location']
        load(new_uri)
      else
        "Status: #{response.status}"
      end
    end
  end
end
