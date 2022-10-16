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
      root.bind('Up') { scroll_up }
      root.bind('MouseWheel') { |event| scroll_wheel(event) }
      @canvas = TkCanvas.new(root) do
        width(WIDTH)
        height(HEIGHT)
      end
      @canvas.pack
      @scroll = 0
      @font = TkFont.new(family: 'Times New Roman', size: 16)
    end

    def draw(text = nil)
      @display_list = layout(text) unless text.nil?
      @canvas.delete('all')

      @display_list.each do |x, y, word|
        break if y > @scroll + HEIGHT # Stop drawing at the bottom of the page.
        next if y + VSTEP < @scroll   # Don't draw about the top of the page.

        @canvas.create(
          'text', x, y - @scroll, font: @font, text: word, anchor: 'nw'
        )
      end
    end

    private

    def scroll_down
      @scroll += SCROLL_STEP
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

    def layout(tokens) # rubocop:disable Metrics
      x = HSTEP
      y = VSTEP
      display_list = []

      newline = @font.metrics('linespace') * 1.25
      space = @font.measure(' ')

      tokens.each do |token|
        next unless token.text?

        token.content.split("\n").each do |line|
          line.split.each do |word|
            width = @font.measure(word)
            if x + width > WIDTH - HSTEP
              x = HSTEP
              y += newline
            end

            display_list << [x, y, word]
            x += width + space
          end

          x = HSTEP
          y += newline
        end
      end

      display_list
    end
  end
end
