require 'spec_helper'

describe AwsCloudSearch::CloudSearch do
  before(:each) do
    @ds = AwsCloudSearch::CloudSearch.new('spoke-dev-1-na4eszv5wms3lahf4xnq27x6ym')

    @doc1 = AwsCloudSearch::Document.new(true)
    @doc1.id = '73e'
    @doc1.lang = 'en'
    @doc1.add_field('name', 'Jane Williams')
    @doc1.add_field('type', 'person')

    @batch = AwsCloudSearch::DocumentBatch.new
  end

  it "should send document batch" do
    @batch.add_document @doc1
    expect { @ds.documents_batch(@batch) }.to_not raise_error
  end

end