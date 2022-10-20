# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

module WeBER
  module HTMLParser
    HEAD_TAGS = %w[
      base basefont bgsound noscript link meta title style script
    ].freeze

    VOID_TAGS = %w[
      area base br col embed hr img input link meta param source track wbr
    ].freeze

    @unfinished = []

    module_function

    def parse(html)
      buf = +''
      in_tag = false

      html.each_char do |c|
        case c
        when '<'
          in_tag = true
          add_text(buf) unless buf.empty?
          buf = +''
        when '>'
          in_tag = false
          add_tag(buf)
          buf = +''
        else
          buf << c
        end
      end

      add_text(buf) unless in_tag || buf.empty?
      finish
    end

    def add_tag(tag) # rubocop:disable Metrics/AbcSize
      return if tag.start_with?('!')

      tag, attributes = attributes(tag)
      add_implicit_tags(tag)
      if tag.start_with?('/')
        return if @unfinished.length == 1

        node = @unfinished.pop
        parent = @unfinished[-1]
        parent.children << node
      elsif VOID_TAGS.include?(tag)
        parent = @unfinished[-1]
        node = Node.tag(parent, tag, attributes)
        parent.children << node
      else
        parent = @unfinished[-1]
        node = Node.tag(parent, tag, attributes)
        @unfinished << node
      end
    end

    def add_text(text)
      return if text.strip.empty?

      add_implicit_tags
      parent = @unfinished[-1]
      node = Node.text(parent, text)
      parent.children << node
    end

    def add_implicit_tags(tag = nil) # rubocop:disable Metrics
      implicit_head_markers = %w[head body /html]
      loop do
        open_tags = @unfinished.map(&:content)
        if open_tags.empty? && tag != 'html'
          add_tag('html')
        elsif open_tags == ['html'] && !implicit_head_markers.include?(tag)
          HEAD_TAGS.include?(tag) ? add_tag('head') : add_tag('body')
        elsif open_tags == %w[html head] && !(HEAD_TAGS + ['/head']).include?(tag)
          add_tag('/head')
        else
          break
        end
      end
    end

    def attributes(text)
      tag, *pairs = text.split
      attributes = {}

      pairs.each do |pair|
        key, value = pair.split(/="(.+)"/)
        next if key == '/'

        attributes[key.downcase] = value.nil? ? '' : value
      end

      [tag.downcase, attributes]
    end

    def finish
      add_tag('html') if @unfinished.empty?

      while @unfinished.length > 1
        node = @unfinished.pop
        parent = @unfinished[-1]
        parent.children << node
      end

      @unfinished.pop
    end

    def print(tree, indent = 0)
      puts (' ' * indent) + tree.inspect
      tree.children.each { |child| print(child, indent + 2) }
    end

    class Node
      TYPES = %i[tag text].freeze

      attr_reader :attributes, :children, :content, :parent, :type

      def initialize(type, parent, content, attributes = nil)
        raise ArgumentError, "Unrecognised type: '#{type}'." unless TYPES.include?(type)

        @type = type
        @parent = parent
        @content = content
        @attributes = attributes
        @children = []
      end

      def self.tag(parent, content, attributes)
        new(:tag, parent, content, attributes)
      end

      def self.text(parent, content)
        new(:text, parent, content)
      end

      def inspect
        if text?
          @content.inspect
        else
          "<#{@content}>".inspect
        end
      end

      def tag?
        @type == :tag
      end

      def text?
        @type == :text
      end
    end
  end
end
