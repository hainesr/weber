# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'adapters'
require_relative 'gui'
require_relative 'gui/document_layout'
require_relative 'parsers/html'
require_relative 'parsers/styler'
require_relative 'uri'

module WeBER
  class Browser
    def initialize
      @window = GUI::Window.new
    end

    def load(uri) # rubocop:disable Metrics/AbcSize
      uri = URI.new(uri.to_s)
      connection = Adapters.adapter_for_uri(uri)
      response = connection.request(uri)

      if response.success?
        doc_tree = Parsers::HTML.new(response.body).parse
        Parsers::Styler.new(doc_tree, uri).apply
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
