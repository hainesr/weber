# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

module WeBER
  class Token
    TYPES = %i[tag text].freeze

    attr_reader :content, :type

    def initialize(content, type)
      raise ArgumentError, "Unrecognised type: '#{type}'." unless TYPES.include?(type)

      @content = content
      @type = type
    end

    def self.tag(content)
      new(content, :tag)
    end

    def self.text(content)
      new(content, :text)
    end

    def tag?
      type == :tag
    end

    def text?
      type == :text
    end
  end
end
