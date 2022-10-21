# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'painter'

module WeBER
  module GUI
    module Painters
      class Rectangle < Painter
        def initialize(left, top, right, bottom, colour)
          super(top, bottom)

          @left = left
          @right = right
          @colour = colour
        end

        def paint(canvas, scroll)
          canvas.create(
            'rectangle', @left, @top - scroll, @right, @bottom - scroll,
            width: 0, fill: @colour
          )
        end
      end
    end
  end
end
