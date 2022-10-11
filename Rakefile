# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require 'bundler/setup'
require 'minitest/test_task'
require 'rubocop/rake_task'

task default: :test

Minitest::TestTask.create do |test|
  test.test_globs = 'test/**/*_test.rb'
end

RuboCop::RakeTask.new
