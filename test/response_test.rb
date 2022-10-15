# frozen_string_literal: true

# WeBER: Web Browser Engineering in Ruby
#
# Robert Haines
#
# Public Domain

require_relative 'test_helper'

require 'weber/response'

class ResponseTest < Minitest::Test
  STATUS_200 = "HTTP/1.1 200 OK\r\n"
  STATUS_301 = "HTTP/1.1 301 Moved Permanently\r\n"

  RESPONSE_BODY = "<html>\r\n<head><title>301 Moved Permanently</title></head>\r\n<body>\r\n<center><h1>301 Moved Permanently</h1></center>\r\n<hr><center>nginx/1.18.0 (Ubuntu)</center>\r\n</body>\r\n</html>\r\n"

  RESPONSE_200 = "#{STATUS_200}Server: nginx/1.18.0 (Ubuntu)\r\nDate: Thu, 13 Oct 2022 16:27:21 GMT\r\nContent-Type: text/html\r\nContent-Length: 178\r\nConnection: close\r\nLocation: https://browser.engineering/index.html\r\n\r\n#{RESPONSE_BODY}".freeze
  RESPONSE_301 = "#{STATUS_301}Server: nginx/1.18.0 (Ubuntu)\r\nDate: Thu, 13 Oct 2022 16:27:21 GMT\r\nContent-Type: text/html\r\nContent-Length: 178\r\nConnection: close\r\nLocation: https://browser.engineering/index.html\r\n\r\n#{RESPONSE_BODY}".freeze

  RESPONSE_HEADERS = {
    'server' => 'nginx/1.18.0 (Ubuntu)',
    'date' => 'Thu, 13 Oct 2022 16:27:21 GMT',
    'content-type' => 'text/html',
    'content-length' => '178',
    'connection' => 'close',
    'location' => 'https://browser.engineering/index.html'
  }.freeze

  def test_http_response_ok
    response = WeBER::Response.from_http(StringIO.new(RESPONSE_200))

    assert_equal(200, response.status)
    response.headers.each do |header, value|
      assert_equal(RESPONSE_HEADERS[header], value)
    end
    assert_equal(RESPONSE_BODY, response.body)
  end
end
