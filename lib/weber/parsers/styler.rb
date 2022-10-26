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

      INHERITED_PROPERTIES = {
        'font-size' => '16px',
        'font-style' => 'normal',
        'font-weight' => 'normal',
        'color' => 'black'
      }.freeze

      def initialize(node, base)
        @node = node
        @css_rules = initialize_css_rules(base)
      end

      def apply(node = @node) # rubocop:disable Metrics
        INHERITED_PROPERTIES.each do |property, default|
          node.style[property] = (node.parent.nil? ? default : node.parent.style[property])
        end

        @css_rules.each do |selector, body|
          next unless selector.matches?(node)

          body.each do |property, value|
            computed_value = computed_style(node, property, value)
            node.style[property] = computed_value unless computed_value.nil?
          end
        end

        if node.tag?
          CSS.new(node.attributes['style']).body.each do |property, value|
            computed_value = computed_style(node, property, value)
            node.style[property] = computed_value
          end
        end

        node.children.each { |child| apply(child) }
      end

      private

      def computed_style(node, property, value)
        return value unless property == 'font-size'
        return value if value.end_with?('px')
        return nil unless value.end_with?('%')

        parent_size =
          (node.parent.nil? ? INHERITED_PROPERTIES['font-size'] : node.parent.style['font-size'])
        node_pct = value.chomp('%').to_f / 100.0
        parent_px = parent_size.chomp('px').to_f

        "#{node_pct * parent_px}px"
      end

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

        # Adding an index here, and using it as a tie-breaker, makes sort_by stable.
        i = 0
        rules.sort_by do |selector, _body|
          i += 1
          [selector.priority, i]
        end
      end
    end
  end
end
