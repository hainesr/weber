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

      while @index < @css.length && @css[@index] != '}'
        begin
          property, value = pair
          pairs[property] = value
          whitespace
          literal(';')
          whitespace
        rescue RuntimeError
          why = ignore_until([';', '}'])
          break unless why == ';'

          literal(';')
          whitespace
        end
      end

      pairs
    end

    def selector
      out = TagSelector.new(word.downcase)
      whitespace

      while @index < @css.length && @css[@index] != '{'
        tag = word
        descendant = TagSelector.new(tag.downcase)
        out = DescendantSelector.new(out, descendant)
        whitespace
      end

      out
    end

    def parse
      rules = []

      while @index < @css.length
        begin
          whitespace
          slctr = selector
          literal('{')
          whitespace
          bdy = body
          literal('}')
          rules << [slctr, bdy]
        rescue RuntimeError
          why = ignore_until(['}'])
          break unless why == '}'

          literal('}')
          whitespace
        end
      end

      rules
    end

    class TagSelector
      def initialize(tag)
        @tag = tag
      end

      def matches?(node)
        node.tag? && (@tag == @node.content)
      end
    end

    class DescendantSelector
      def initialize(ancestor, descendant)
        @ancestor = ancestor
        @descendant = descendant
      end

      def matches?(node)
        return false unless @descendant.matches?(node)

        until node.parent.nil?
          return true if @ancestor.matches?(node.parent)

          node = node.parent
        end

        false
      end
    end
  end
end
