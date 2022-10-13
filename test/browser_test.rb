# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'test_helper'

require 'weber/browser'

class BrowserTest < Minitest::Test
  def test_show
    assert_equal(
      'hello, world!', WeBER::Browser.show('<span>hello, <i>world</i>!</span>')
    )
  end
end
