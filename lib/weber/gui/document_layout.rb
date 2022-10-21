# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'block_layout'
require_relative 'layout'

module WeBER
  module GUI
    class DocumentLayout < Layout
      def initialize(node)
        super

        layout
      end

      def paint
        @children[0].paint
      end

      private

      def layout
        child = BlockLayout.new(@node, self, nil)
        @children << child

        @x = LAYOUT_HSTEP
        @y = LAYOUT_VSTEP
        @width = WINDOW_WIDTH - (2 * LAYOUT_HSTEP)

        child.layout

        @height = child.height + (2 * LAYOUT_VSTEP)
      end
    end
  end
end
