require 'spec_helper'

describe AwsCloudSearch::DocumentService do
  before(:each) do
    @ds = AwsCloudSearch::DocumentService.new('spoke-dev-1-na4eszv5wms3lahf4xnq27x6ym')
    @doc1 = AwsCloudSearch::Document.new(true)
    @doc1.id = '73E'
    @doc1.lang = 'en'
    @doc1.add_field('name', 'Jane Williams')
    @doc1.add_field('type', 'person')
  end

  it "should return the batch size" do
    @ds.batch_size.should equal(0)

    @ds.add_document @doc1
    @ds.batch_size.should equal(1)

    @doc1.new_version
    @ds.delete_document @doc1
    @ds.batch_size.should equal(2)
  end

  it "should send the document to AWS" do
    @ds.add_document @doc1
    expect { resp = @ds.send_batch }.to_not raise_error
  end

end