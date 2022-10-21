# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require 'tk'

require_relative 'font_cache'
require_relative 'layout'
require_relative 'painters/rectangle'
require_relative 'painters/text'

module WeBER
  module GUI
    class InlineLayout < Layout
      def initialize(node, parent, previous)
        super

        @font_size = 16
        @font_weight = 'normal'
        @font_slant = 'roman'
        @display_list = []
      end

      def layout
        @x = @parent.x
        @y = initial_y
        @width = @parent.width
        @cursor_x = @x
        @cursor_y = @y

        line = []
        traverse(@node, line)
        flush(line)

        @height = @cursor_y - @y
        @display_list
      end

      def paint
        bg =
          if @node.tag? && @node.content == 'pre'
            [Painters::Rectangle.new(@x, @y, @x + @width, @y + @height, 'gray')]
          end || []

        bg + @display_list.map do |x, y, font, text|
          Painters::Text.new(x, y, font, text)
        end
      end

      private

      def traverse(node, current_line = [])
        if node.text?
          text(node, current_line)
        else
          open_tag(node, current_line)
          node.children.each { |child| traverse(child, current_line) }
          close_tag(node, current_line)
        end
      end

      def open_tag(tag, current_line)
        case tag.content
        when 'i'
          @font_slant = 'italic'
        when 'b'
          @font_weight = 'bold'
        when 'small'
          @font_size -= 2
        when 'large'
          @font_size += 4
        when 'br'
          flush(current_line)
        end
      end

      def close_tag(tag, current_line)
        case tag.content
        when 'i'
          @font_slant = 'roman'
        when 'b'
          @font_weight = 'normal'
        when 'small'
          @font_size += 2
        when 'large'
          @font_size -= 4
        when 'p'
          flush(current_line)
          @cursor_y += LAYOUT_VSTEP
        when 'body'
          flush(current_line)
        end
      end

      def text(text, line)
        font = FontCache.font(@font_size, @font_weight, @font_slant)
        text.content.split.each do |word|
          width = font.measure(word)
          flush(line) if @cursor_x + width > WINDOW_WIDTH - LAYOUT_HSTEP

          line << [@cursor_x, font, word]
          @cursor_x += width + font.measure(' ')
        end
      end

      def flush(line)
        return if line.empty?

        max_ascent, max_descent = font_limits(line)
        baseline = @cursor_y + (1.25 * max_ascent)

        line.each do |x, font, word|
          y = baseline - font.metrics('ascent')
          @display_list << [x, y, font, word]
        end

        line.replace([])
        @cursor_x = LAYOUT_HSTEP
        @cursor_y = baseline + (1.25 * max_descent)
      end

      def font_limits(line)
        metrics = line.map do |_, font, _|
          [font.metrics('ascent'), font.metrics('descent')]
        end
        max_ascent = metrics.max_by { |metric| metric[0] }[0]
        max_descent = metrics.max_by { |metric| metric[1] }[1]

        [max_ascent, max_descent]
      end
    end
  end
end
