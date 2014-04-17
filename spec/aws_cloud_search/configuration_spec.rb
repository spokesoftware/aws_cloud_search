require 'spec_helper'
require 'pp'

describe AWSCloudSearch::Configuration do

  it "should let you configure the region and api verison and domain" do

    AWSCloudSearch.configure do |config|
      config.api_version = '2011-02-01'
      config.region      = 'us-east-1'
      config.domain      = 'test-plbebu2asyirmxnxpi2ybd5gly'
    end

    AWSCloudSearch.config.api_version.should eq("2011-02-01")
    AWSCloudSearch.config.region.should eq("us-east-1")
    AWSCloudSearch.config.domain.should eq("test-plbebu2asyirmxnxpi2ybd5gly")

    expected_base_path = "test-plbebu2asyirmxnxpi2ybd5gly.us-east-1.cloudsearch.amazonaws.com/2011-02-01"

    AWSCloudSearch.config.base_path.should eq(expected_base_path)
    AWSCloudSearch.config.search_url.should eq("http://search-#{expected_base_path}")
    AWSCloudSearch.config.document_url.should eq("http://doc-#{expected_base_path}")
  end


end