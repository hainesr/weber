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
      class Text < Painter
        def initialize(left, top, font, colour, text)
          @left = left
          @font = font
          @colour = colour
          @text = text

          super(top, top + @font.metrics('linespace'))
        end

        def paint(canvas, scroll)
          canvas.create(
            'text', @left, @top - scroll,
            font: @font, fill: @colour, text: @text, anchor: 'nw'
          )
        end
      end
    end
  end
end
