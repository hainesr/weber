# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require 'tk'

module WeBER
  class Window
    WIDTH  = 800
    HEIGHT = 600
    SCROLL_STEP = 100

    def initialize
      root = TkRoot.new
      root.bind('Down') { scroll_down }
      @canvas = TkCanvas.new(root) do
        width(WIDTH)
        height(HEIGHT)
      end
      @canvas.pack
      @scroll = 0
    end

    def draw(display_list = @display_list)
      @display_list ||= display_list
      @canvas.delete('all')

      @display_list.each do |x, y, c|
        @canvas.create('text', x, y - @scroll, text: c)
      end
    end

    def scroll_down
      @scroll += SCROLL_STEP
      draw
    end

    def width
      WIDTH
    end
  end
end
