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
    @data  = 'data'
    @file  = 'file'
    @https = 'https'
    @http  = 'http'
    @host  = 'example.org'
    @media = 'text/html'
    @port  = 8080
    @path  = '/this/is/a/path'
    @text  = 'Hello, world!'

    @data_uri  = WeBER::URI.new("#{@data}:#{@media},#{@text}")
    @file_uri  = WeBER::URI.new("#{@file}://#{@path}")
    @https_uri = WeBER::URI.new("#{@https}://#{@host}#{@path}")
    @http_uri  = WeBER::URI.new("#{@http}://#{@host}:#{@port}#{@path}")
  end

  def test_scheme
    assert_equal(@data, @data_uri.scheme)
    assert_equal(@file, @file_uri.scheme)
    assert_equal(@https, @https_uri.scheme)
    assert_equal(@http, @http_uri.scheme)
  end

  def test_host
    assert_nil(@data_uri.host)
    assert_nil(@file_uri.host)
    assert_equal(@host, @https_uri.host)
    assert_equal(@host, @http_uri.host)
  end

  def test_path
    assert_nil(@data_uri.path)
    assert_equal(@path, @file_uri.path)
    assert_equal(@path, @https_uri.path)
    assert_equal(@path, @http_uri.path)
  end

  def test_port
    assert_nil(@data_uri.port)
    assert_nil(@file_uri.port)
    assert_nil(@https_uri.port)
    assert_equal(@port, @http_uri.port)
  end

  def test_data
    assert_equal(@text, @data_uri.data)
    assert_nil(@file_uri.data)
    assert_nil(@https_uri.data)
    assert_nil(@http_uri.data)
  end

  def test_media_type
    assert_equal(@media, @data_uri.media_type)
    assert_nil(@file_uri.media_type)
    assert_nil(@https_uri.media_type)
    assert_nil(@http_uri.media_type)
  end
end
