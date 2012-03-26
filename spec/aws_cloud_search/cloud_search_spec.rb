require 'spec_helper'

describe AwsCloudSearch::CloudSearch do

  let(:ds) { AwsCloudSearch::CloudSearch.new('spoke-dev-1-na4eszv5wms3lahf4xnq27x6ym') }

  it "should send document batch" do
    batch = AwsCloudSearch::DocumentBatch.new
    
    doc1 = AwsCloudSearch::Document.new(true)
    doc1.id = '73e'
    doc1.lang = 'en'
    doc1.add_field('name', 'Jane Williams')
    doc1.add_field('type', 'person')

    batch.add_document doc1
    ds.documents_batch(batch)
  end

end