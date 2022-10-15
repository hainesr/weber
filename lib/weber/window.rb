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

    def initialize
      root = TkRoot.new
      @canvas = TkCanvas.new(root) do
        width(WIDTH)
        height(HEIGHT)
      end
      @canvas.pack
    end

    def draw(text)
      cursor_x = HSTEP
      cursor_y = VSTEP

      text.each_char do |c|
        @canvas.create('text', cursor_x, cursor_y, text: c)
        cursor_x += HSTEP
        if cursor_x > WIDTH - HSTEP
          cursor_x = HSTEP
          cursor_y += VSTEP
        end
      end
    end
  end
end
