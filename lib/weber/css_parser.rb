# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

module WeBER
  class CSSParser
    def initialize(css)
      @css = css || ''
      @index = 0
    end

    def whitespace
      @index += 1 while @index < @css.length && @css[@index].match?(/[[:space:]]/)
    end

    def word
      start = @index
      while @index < @css.length
        break unless @css[@index].match?(/[[:alnum:]#%\-.]/)

        @index += 1
      end

      raise 'CSS Parser: word not found.' unless @index > start

      @css[start...@index]
    end

    def literal(literal)
      raise unless @index < @css.length && @css[@index] == literal

      @index += 1
    end

    def pair
      property = word
      whitespace
      literal(':')
      whitespace
      value = word

      [property.downcase, value]
    end

    def ignore_until(chars)
      while @index < @css.length
        return @css[@index] if chars.include?(@css[@index])

        @index += 1
      end
    end

    def body
      pairs = {}

      while @index < @css.length
        begin
          property, value = pair
          pairs[property] = value
          whitespace
          literal(';')
          whitespace
        rescue RuntimeError
          why = ignore_until([';'])
          break unless why == ';'

          literal(';')
          whitespace
        end
      end

      pairs
    end
  end
end
