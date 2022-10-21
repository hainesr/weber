# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'inline_layout'
require_relative 'layout'

module WeBER
  module GUI
    class BlockLayout < Layout
      def layout
        previous = nil
        @node.children.each do |child|
          next_block = layout_mode(child).new(child, self, previous)
          @children << next_block
          previous = next_block
        end

        @x = @parent.x
        @y = initial_y
        @width = @parent.width

        @children.each(&:layout)

        @height = @children.sum(&:height)
      end

      def paint
        @children.sum([], &:paint)
      end
    end
  end
end
