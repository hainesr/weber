# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require 'tk'

module WeBER
  module GUI
    class Window
      def initialize
        root = TkRoot.new
        root.bind('Down') { scroll_down }
        root.bind('Up') { scroll_up }
        root.bind('MouseWheel') { |event| scroll_wheel(event) }
        root.bind('Escape') { Tk.exit }
        @canvas = TkCanvas.new(
          root, width: WINDOW_WIDTH, height: WINDOW_HEIGHT, bg: 'white'
        )
        @canvas.pack
        @scroll = 0
      end

      def draw(tree = nil)
        @display_list = tree.paint unless tree.nil?
        @canvas.delete('all')

        @display_list.each do |element|
          break if element.top > @scroll + WINDOW_HEIGHT # Stop drawing at the bottom of the page.
          next if element.bottom < @scroll               # Don't draw above the top of the page.

          element.paint(@canvas, @scroll)
        end
      end

      private

      def scroll_down
        max_y = @display_list[-1].bottom - WINDOW_HEIGHT
        @scroll = [@scroll + SCROLL_STEP, max_y].min unless max_y.negative?
        draw
      end

      def scroll_up
        @scroll -= SCROLL_STEP
        @scroll = 0 if @scroll.negative?
        draw
      end

      def scroll_wheel(event)
        event.wheel_delta.negative? ? scroll_down : scroll_up
      end
    end
  end
end
