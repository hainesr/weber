# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

module WeBER
  module GUI
    module Painters
      class Text
        attr_reader :bottom, :top

        def initialize(x, y, font, text)
          @left = x
          @top = y
          @font = font
          @text = text
          @bottom = @top + @font.metrics('linespace')
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
