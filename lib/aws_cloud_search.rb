require "aws_cloud_search/cloud_search_config"
require "aws_cloud_search/document"
require "aws_cloud_search/document_batch"
require "aws_cloud_search/document_batcher"
require "aws_cloud_search/document_service"
require "aws_cloud_search/search_request"
require "aws_cloud_search/search_service"
require "aws_cloud_search/version"

require "faraday_middleware"

module AwsCloudSearch
  API_VERSION = "2011-02-01"


  def self.search_url(domain, region="us-east-1")
    "http://search-#{domain}.#{region}.cloudsearch.amazonaws.com"
  end

  def self.document_url(domain, region="us-east-1")
    "http://doc-#{domain}.#{region}.cloudsearch.amazonaws.com"
  end

  def self.configuration_url
    "https://cloudsearch.us-east-1.amazonaws.com"
  end

  # Initialize the module
  # @param [String] url
  # @param [String] aws_access_key_id
  # @param [String] aws_secret_access_key
  def self.create_connection(url, aws_access_key_id=nil, aws_secret_access_key=nil)
    connection = Faraday.new url do |builder|
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



end
