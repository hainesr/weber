# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'test_helper'

require 'weber/parsers/html'

class HTMLParserTest < Minitest::Test
  def test_node_bad_type
    assert_raises(ArgumentError) do
      WeBER::Parsers::HTML::Node.new(:wrong, 'parent', 'content')
    end
  end

  def test_node_tag
    tag = WeBER::Parsers::HTML::Node.tag('parent', 'b', 'attributes')

    assert_equal('parent', tag.parent)
    assert_equal('b', tag.content)
    assert_empty(tag.children)
    assert_predicate(tag, :tag?)
  end

  def test_node_text
    text = WeBER::Parsers::HTML::Node.text('parent', 'content')

    assert_equal('parent', text.parent)
    assert_equal('content', text.content)
    assert_empty(text.children)
    assert_predicate(text, :text?)
  end

  def test_parser_implicit_tags
    parser = WeBER::Parsers::HTML.new('Test', '')
    tree = parser.parse
    assert_equal('html', tree.content)

    tree = tree.children[0]
    assert_equal('body', tree.content)

    tree = tree.children[0]
    assert_equal('Test', tree.content)
  end

  def test_parser_comment
    parser = WeBER::Parsers::HTML.new('<!-- comment -->', '')
    tree = parser.parse
    assert_equal('html', tree.content)
    assert_empty(tree.children)
  end
end
