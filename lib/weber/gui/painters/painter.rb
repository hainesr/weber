# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

module WeBER
  module GUI
    module Painters
      class Painter
        attr_reader :bottom, :top

        def initialize(top, bottom)
          @top = top
          @bottom = bottom
        end
      end
    end
  end
end
