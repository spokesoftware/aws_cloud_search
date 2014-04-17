require "singleton"

module AWSCloudSearch
  class Configuration
    include Singleton

    VALID_API_VERSIONS = ['2011-02-11','2013-01-01']

    attr_accessor :api_version, :domain, :region

    def api_version
      @api_version ||= VALID_API_VERSIONS.first
    end

    def region
      @region ||= "us-east-1"
    end

    def configuration_url
      "https://cloudsearch.#{region}.amazonaws.com"
    end

    def document_url
      "http://doc-#{base_path}"
    end

    def search_url
      "http://search-#{base_path}"
    end

    def base_path
      "#{domain}.#{region}.cloudsearch.amazonaws.com/#{api_version}"
    end

  end
end