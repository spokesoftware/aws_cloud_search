require "aws_cloud_search/cloud_search"
require "aws_cloud_search/configuration"
require "aws_cloud_search/document"
require "aws_cloud_search/document_batch"
require "aws_cloud_search/document_batcher"
require "aws_cloud_search/exceptions"
require "aws_cloud_search/search_response"
require "aws_cloud_search/search_request"
require "aws_cloud_search/version"

require "faraday_middleware"

module AWSCloudSearch

  # AWS CloudSearch only allows XML 1.0 valid characters
  INVALID_CHAR_XML10 = /[^\u0009\u000a\u000d\u0020-\uD7FF\uE000-\uFFFD]/m
  # for future reference in case AWS-CS updates to XML 1.1 char compliance
  #INVALID_CHAR_XML11 = /[^\u0001-\uD7FF\uE000-\uFFFD]/m

  def self.config
    AWSCloudSearch::Configuration.instance
  end

  def self.configure(&block)
    block.call(self.config)
  end

  # Initialize the module
  # @param [String] url
  # @param [String] aws_access_key_id
  # @param [String] aws_secret_access_key
  def self.create_connection(url, aws_access_key_id=nil, aws_secret_access_key=nil)
    connection = Faraday.new url do |builder|
      builder.use AWSCloudSearch::HttpCodeResponseMiddleware
      builder.use FaradayMiddleware::EncodeJson
      builder.use FaradayMiddleware::ParseJson
      builder.adapter Faraday.default_adapter

      # for future reference
      #conn.request :json, :content_type => /\bjson$/
      #conn.response :json, :content_type => /\bjson$/
      #conn.adapter Faraday.default_adapter
    end
    connection.headers['User-Agent'] = "AWSCloudSearch-Ruby-Client/#{VERSION}"
    connection
  end

  # Escape single-quote and backslash chars in the str so that the resulting string is suitable as a query argument.
  # @param [Object] str
  def self.escape(str)
    return str if (str.nil? or not str.is_a? String)
    str.gsub(/\\/, "\\\\\\").gsub(/'/, "\\\\'")
  end

  class HttpCodeResponseMiddleware < Faraday::Response::Middleware
    def on_complete(env)
      case env[:status]
        when 200..299
          nil
        when 408
          raise RequestTimeout, env[:body]
        when 400..499
          raise HttpClientError, env[:body]
        when 509
          raise BandwidthLimitExceeded, env[:body]
        when 500..599
          raise HttpServerError, env[:body]
        else
          raise UnexpectedHTTPException, env[:body]
      end
    end

    def initialize(app)
      super
      @parser = nil
    end
  end


end
