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
        def initialize(left, top, font, text)
          @left = left
          @font = font
          @text = text

          super(top, top + @font.metrics('linespace'))
        end

        def paint(canvas, scroll)
          canvas.create(
            'text', @left, @top - scroll, font: @font, text: @text, anchor: 'nw'
          )
        end
      end
    end
  end
end