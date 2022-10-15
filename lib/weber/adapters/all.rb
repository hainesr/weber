# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'file'
require_relative 'socket'

module WeBER
  module Adapters
    register_adapter(File, :file)
    register_adapter(Socket, :http, :https)
  end
end
