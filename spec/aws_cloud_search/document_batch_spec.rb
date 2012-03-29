require 'spec_helper'

describe AwsCloudSearch::DocumentBatch do

  let(:batch) { AwsCloudSearch::DocumentBatch.new }

  let(:sample_add_doc) do
    AwsCloudSearch::Document.new(true).tap do |d|
      d.id = '73e'
      d.lang = 'en'
      d.add_field('name', 'Jane Williams')
      d.add_field('type', 'person')
    end
  end

  let(:sample_delete_doc) do
    AwsCloudSearch::Document.new(true).tap do |d|
      d.id = '47p'
      d.lang = nil
    end
  end

  it "should should not instantiate" do
    expect { AwsCloudSearch::DocumentBatch.new(100, 100) }.to raise_error(ArgumentError)
    expect { AwsCloudSearch::DocumentBatch.new(101, 100) }.to raise_error(ArgumentError)
  end

  it "should instantiate" do
    expect { AwsCloudSearch::DocumentBatch.new }.to_not raise_error
    expect { AwsCloudSearch::DocumentBatch.new(100, 101) }.to_not raise_error
  end

  it "should raise error when passed an invalid object type" do
    expect { batch.add_document("Hello") }.to raise_error(ArgumentError)
    expect { batch.delete_document("Hello") }.to raise_error(ArgumentError)
  end

  it "should not raise error when passed a Document" do
    expect { batch.add_document(sample_add_doc) }.to_not raise_error(ArgumentError)
    expect { batch.delete_document(sample_delete_doc) }.to_not raise_error(ArgumentError)
  end

  it "should return the correct size" do
    batch.add_document sample_add_doc
    batch.size.should eq(1)

    batch.delete_document sample_delete_doc
    batch.size.should eq(2)
  end

  it "should raise error when the max batch size is exceeded" do
    small_batch = AwsCloudSearch::DocumentBatch.new(1, 10)
    expect { small_batch.add_document(sample_add_doc) }.to raise_error
    expect { small_batch.delete_document(sample_delete_doc) }.to raise_error
  end

  it "should be full" do
    bytesize = sample_add_doc.to_json.bytesize

    b1 = AwsCloudSearch::DocumentBatch.new(bytesize)
    b1.add_document sample_add_doc
    b1.full?.should be_true

    b2 = AwsCloudSearch::DocumentBatch.new(bytesize-1)
    b2.add_document sample_add_doc
    b2.full?.should be_true

    bytesize = sample_delete_doc.to_json.bytesize

    b3 = AwsCloudSearch::DocumentBatch.new(bytesize)
    b3.delete_document sample_delete_doc
    b3.full?.should be_true

    b4 = AwsCloudSearch::DocumentBatch.new(bytesize-1)
    b4.delete_document sample_delete_doc
    b4.full?.should be_true
  end

  it "should return the total bytesize of all docs" do
    batch.bytesize.should eq(0)

    batch.add_document sample_add_doc
    bytesize = sample_add_doc.to_json.bytesize
    batch.bytesize.should eq(bytesize)

    batch.delete_document sample_delete_doc
    bytesize += sample_delete_doc.to_json.bytesize
    batch.bytesize.should eq(bytesize)
  end

  it "should not be full" do
    batch.add_document sample_add_doc
    batch.full?.should_not be_true

    batch.delete_document sample_add_doc
    batch.full?.should_not be_true
  end

  it "should clear" do
    clear_batch = AwsCloudSearch::DocumentBatch.new
    clear_batch.add_document sample_add_doc
    clear_batch.delete_document sample_delete_doc

    clear_batch.bytesize.should be > 0
    clear_batch.size.should be > 0

    clear_batch.clear

    clear_batch.bytesize.should eq(0)
    clear_batch.size.should eq(0)
  end

end
