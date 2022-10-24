# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'test_helper'

require 'weber/parsers/css'

class CSSParserTest < Minitest::Test
  def test_whitespace
    spaces = " \n\r\t  "
    parser = WeBER::Parsers::CSS.new(spaces)

    parser.whitespace
    assert_equal(spaces.length, parser.instance_variable_get(:@index))
  end

  def test_word
    words = '#fi%r.st1-|second'
    parser = WeBER::Parsers::CSS.new(words)
    assert_equal('#fi%r.st1-', parser.word)

    no_words = '|!@£$'
    parser = WeBER::Parsers::CSS.new(no_words)
    assert_raises(RuntimeError) { parser.word }
  end

  def test_literal
    literal = ':'
    parser = WeBER::Parsers::CSS.new(literal)

    parser.literal(':')
    assert_equal(1, parser.instance_variable_get(:@index))

    assert_raises(RuntimeError) { parser.literal(':') }
  end

  def test_pair
    property = 'Key : Value'
    parser = WeBER::Parsers::CSS.new(property)

    assert_equal(['key', 'Value'], parser.pair)
  end

  def test_ignore_until
    text = 'word;word|word!word'
    chars = %w[; | !]
    parser = WeBER::Parsers::CSS.new(text)

    chars.each do |literal|
      assert_equal(literal, parser.ignore_until(chars))
      parser.literal(literal) # Move past the found char.
    end
  end

  def test_body
    body = "background-color:lightblue;key:value ;\n;ERROR!;Property:default"
    parser = WeBER::Parsers::CSS.new(body)

    assert_equal(
      {
        'background-color' => 'lightblue',
        'key' => 'value',
        'property' => 'default'
      },
      parser.body
    )
  end

  def test_nil_css
    parser = WeBER::Parsers::CSS.new(nil)

    parser.whitespace
    assert_raises(RuntimeError) { parser.word }
    assert_raises(RuntimeError) { parser.literal(';') }
    assert_raises(RuntimeError) { parser.pair }
    parser.ignore_until([';'])
    assert_empty(parser.body)
  end

  def test_parse
    css = 'pre { background-color: gray; }'
    parser = WeBER::Parsers::CSS.new(css)
    rules = parser.parse

    assert_instance_of(WeBER::Parsers::CSS::TagSelector, rules[0][0])
    assert_equal({ 'background-color' => 'gray' }, rules[0][1])
  end
end
