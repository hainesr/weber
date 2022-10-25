# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'css'

module WeBER
  module Parsers
    class Styler
      BROWSER_CSS = ::File.join(::File.expand_path(__dir__), 'browser.css')
      DEFAULT_CSS_RULES = CSS.new(::File.read(BROWSER_CSS)).parse

      def initialize(node, base)
        @node = node
        @css_rules = initialize_css_rules(base)
      end

      def apply(node = @node)
        @css_rules.each do |selector, body|
          next unless selector.matches?(node)

          body.each do |property, value|
            node.style[property] = value
          end
        end

        node.style.merge!(CSS.new(node.attributes['style']).body) if node.tag?

        node.children.each { |child| apply(child) }
      end

      private

      def initialize_css_rules(base) # rubocop:disable Metrics
        rules = DEFAULT_CSS_RULES.dup

        @node.children.each do |child|
          next unless child.content == 'head'

          child.children.each do |tag|
            next unless tag.content == 'link' && tag.attributes['rel'] == 'stylesheet'

            uri = URI.new(tag.attributes['href']).resolve_against(base)
            connection = Adapters.adapter_for_uri(uri)
            response = connection.request(uri)

            rules += CSS.new(response.body).parse if response.success?
          end
        end

        rules.sort_by { |selector, _body| selector.priority }
      end
    end
  end
end
