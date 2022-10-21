# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

module WeBER
  module GUI
    # Forward references so we can return BlockLayout or InlineLayout from
    # layout_mode without recursive dependencies.
    class Layout; end # rubocop:disable Lint/EmptyClass
    class BlockLayout < Layout; end
    class InlineLayout < Layout; end

    class Layout
      BLOCK_ELEMENTS = %w[
        html body article section nav aside h1 h2 h3 h4 h5 h6 hgroup header
        footer address p hr pre blockquote ol ul menu li dl dt dd figure
        figcaption main div table form fieldset legend details summary
      ].freeze

      attr_reader :children, :height, :node, :parent, :width, :x, :y

      def initialize(node, parent = nil, previous = nil)
        @node = node
        @parent = parent
        @previous = previous
        @children = []
      end

      private

      def initial_y
        @previous.nil? ? @parent.y : @previous.y + @previous.height
      end

      def layout_mode(node)
        return InlineLayout if node.text?
        return BlockLayout if node.children.empty?

        node.children.each do |child|
          next if child.text?

          return BlockLayout if BLOCK_ELEMENTS.include?(child.content)
        end

        InlineLayout
      end
    end
  end
end
