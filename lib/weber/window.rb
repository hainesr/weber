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

    def initialize
      root = TkRoot.new
      @canvas = TkCanvas.new(root) do
        width(WIDTH)
        height(HEIGHT)
      end
      @canvas.pack
    end

    def draw(display_list)
      display_list.each do |x, y, c|
        @canvas.create('text', x, y, text: c)
      end
    end

    def width
      WIDTH
    end
  end
end
