# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

module WeBER
  module GUI
    WINDOW_WIDTH  = 800
    WINDOW_HEIGHT = 600
    LAYOUT_HSTEP  = 13
    LAYOUT_VSTEP  = 18
    SCROLL_STEP   = 100
  end
end

require_relative 'gui/window'
