# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'test_helper'

require 'weber/uri'

class URITest < Minitest::Test
  def setup
    @https = 'https'
    @http  = 'http'
    @host  = 'example.org'
    @port  = 8080
    @path  = '/this/is/a/path'

    @https_uri = WeBER::URI.new("#{@https}://#{@host}#{@path}")
    @http_uri  = WeBER::URI.new("#{@http}://#{@host}:#{@port}#{@path}")
  end

  def test_scheme
    assert_equal(@https, @https_uri.scheme)
    assert_equal(@http, @http_uri.scheme)
  end

  def test_host
    assert_equal(@host, @https_uri.host)
    assert_equal(@host, @http_uri.host)
  end

  def test_path
    assert_equal(@path, @https_uri.path)
    assert_equal(@path, @http_uri.path)
  end

  def test_port
    assert_nil(@https_uri.port)
    assert_equal(@port, @http_uri.port)
  end
end
