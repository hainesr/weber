# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'test_helper'

require 'weber/token'

class TokenTest < Minitest::Test
  def test_bad_type
    assert_raises(ArgumentError) do
      WeBER::Token.new('content', :wrong)
    end
  end

  def test_tag
    tag = WeBER::Token.tag('b')

    assert_equal('b', tag.content)
    assert_equal(:tag, tag.type)
    assert_predicate(tag, :tag?)
  end

  def test_text
    text = WeBER::Token.text('content')

    assert_equal('content', text.content)
    assert_equal(:text, text.type)
    assert_predicate(text, :text?)
  end
end
