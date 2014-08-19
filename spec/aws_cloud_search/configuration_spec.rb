require 'spec_helper'
require 'pp'

describe AWSCloudSearch::Configuration do

  it "should let you configure the region and api verison and domain" do

    AWSCloudSearch.configure do |config|
      config.api_version = '2011-02-01'
      config.region      = 'us-east-1'
      config.domain      = 'test-plbebu2asyirmxnxpi2ybd5gly'
    end

    expect(AWSCloudSearch.config.api_version).to eq("2011-02-01")
    expect(AWSCloudSearch.config.region).to eq("us-east-1")
    expect(AWSCloudSearch.config.domain).to eq("test-plbebu2asyirmxnxpi2ybd5gly")

    expected_base_path = "test-plbebu2asyirmxnxpi2ybd5gly.us-east-1.cloudsearch.amazonaws.com/2011-02-01"

    expect(AWSCloudSearch.config.base_path).to eq(expected_base_path)
    expect(AWSCloudSearch.config.search_url).to eq("http://search-#{expected_base_path}")
    expect(AWSCloudSearch.config.document_url).to eq("http://doc-#{expected_base_path}")
  end


end
