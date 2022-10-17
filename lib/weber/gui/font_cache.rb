# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require 'tk'

module WeBER
  module GUI
    module FontCache
      @fonts = {}

      def self.font(size, weight, slant)
        key = [size, weight, slant]

        unless @fonts.key?(key)
          @fonts[key] = TkFont.new(
            family: 'Times New Roman', size: size, weight: weight, slant: slant
          )
        end

        @fonts[key]
      end
    end
  end
end
