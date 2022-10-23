# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'test_helper'

require 'weber/html_parser'

class HTMLParserTest < Minitest::Test
  def test_node_bad_type
    assert_raises(ArgumentError) do
      WeBER::HTMLParser::Node.new(:wrong, 'parent', 'content')
    end
  end

  def test_node_tag
    tag = WeBER::HTMLParser::Node.tag('parent', 'b', 'attributes')

    assert_equal('parent', tag.parent)
    assert_equal('b', tag.content)
    assert_empty(tag.children)
    assert_predicate(tag, :tag?)
  end

  def test_node_style
    attributes = {
      'charset' => 'utf-8',
      'style' => 'background-color:lightblue'
    }

    tag = WeBER::HTMLParser::Node.tag('parent', 'b', {})
    assert_empty(tag.style)

    tag = WeBER::HTMLParser::Node.tag('parent', 'b', attributes)
    assert_equal('lightblue', tag.style['background-color'])
  end

  def test_node_text
    text = WeBER::HTMLParser::Node.text('parent', 'content')

    assert_equal('parent', text.parent)
    assert_equal('content', text.content)
    assert_empty(text.children)
    assert_predicate(text, :text?)
  end

  def test_parser_implicit_tags
    tree = WeBER::HTMLParser.parse('Test')
    assert_equal('html', tree.content)

    tree = tree.children[0]
    assert_equal('body', tree.content)

    tree = tree.children[0]
    assert_equal('Test', tree.content)
  end

  def test_parser_comment
    tree = WeBER::HTMLParser.parse('<!-- comment -->')
    assert_equal('html', tree.content)
    assert_empty(tree.children)
  end
end
