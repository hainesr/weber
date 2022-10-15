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
    HSTEP  = 13
    VSTEP  = 18
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

    def draw(text = nil)
      @display_list = layout(text) unless text.nil?
      @canvas.delete('all')

      @display_list.each do |x, y, c|
        break if y > @scroll + HEIGHT # Stop drawing at the bottom of the page.
        next if y + VSTEP < @scroll   # Don't draw about the top of the page.

        @canvas.create('text', x, y - @scroll, text: c)
      end
    end

    private

    def scroll_down
      @scroll += SCROLL_STEP
      draw
    end

    def layout(text)
      x = HSTEP
      y = VSTEP
      display_list = []

      text.each_char do |c|
        if c == "\n"
          x = HSTEP
          y += VSTEP
          next
        end

        display_list << [x, y, c]
        x += HSTEP
        if x > WIDTH - HSTEP
          x = HSTEP
          y += VSTEP
        end
      end

      display_list
    end
  end
end
