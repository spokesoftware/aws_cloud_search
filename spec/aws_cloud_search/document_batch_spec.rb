require 'spec_helper'

describe AWSCloudSearch::DocumentBatch do

  let(:batch) { AWSCloudSearch::DocumentBatch.new }

  let(:sample_add_doc) do
    AWSCloudSearch::Document.new(true).tap do |d|
      d.id = '73e'
      d.lang = 'en'
      d.add_field('name', 'Jane Williams')
      d.add_field('type', 'person')
    end
  end

  let(:sample_delete_doc) do
    AWSCloudSearch::Document.new(true).tap do |d|
      d.type = 'delete' # we have to set this here so that delete doc bytesize calculations are correct
      d.id = '47p'
      d.lang = nil
    end
  end

  it "should should not instantiate" do
    expect { AWSCloudSearch::DocumentBatch.new(100, 100) }.to raise_error(ArgumentError)
    expect { AWSCloudSearch::DocumentBatch.new(101, 100) }.to raise_error(ArgumentError)
  end

  it "should instantiate" do
    expect { AWSCloudSearch::DocumentBatch.new }.to_not raise_error
    expect { AWSCloudSearch::DocumentBatch.new(100, 101) }.to_not raise_error
  end

  it "should raise error when passed an invalid object type" do
    expect { batch.add_document("Hello") }.to raise_error(ArgumentError)
    expect { batch.delete_document("Hello") }.to raise_error(ArgumentError)
  end

  it "should not raise error when passed a Document" do
    expect { batch.add_document(sample_add_doc) }.to_not raise_error
    expect { batch.delete_document(sample_delete_doc) }.to_not raise_error
  end

  it "should return the correct size" do
    batch.add_document sample_add_doc
    expect(batch.size).to eq(1)

    batch.delete_document sample_delete_doc
    expect(batch.size).to eq(2)
  end

  it "should raise error when the max batch size is exceeded" do
    small_batch = AWSCloudSearch::DocumentBatch.new(1, 10)
    expect { small_batch.add_document(sample_add_doc) }.to raise_error
    expect { small_batch.delete_document(sample_delete_doc) }.to raise_error
  end

  it "should be full" do
    bytesize = sample_add_doc.to_json.bytesize

    b1 = AWSCloudSearch::DocumentBatch.new(bytesize)
    b1.add_document sample_add_doc
    expect(b1.full?).to be_truthy

    b2 = AWSCloudSearch::DocumentBatch.new(bytesize-1)
    b2.add_document sample_add_doc
    expect(b2.full?).to be_truthy

    bytesize = sample_delete_doc.to_json.bytesize

    b3 = AWSCloudSearch::DocumentBatch.new(bytesize)
    b3.delete_document sample_delete_doc
    expect(b3.full?).to be_truthy

    b4 = AWSCloudSearch::DocumentBatch.new(bytesize-1)
    b4.delete_document sample_delete_doc
    expect(b4.full?).to be_truthy
  end

  it "should return the total bytesize of all docs" do
    expect(batch.bytesize).to eq(0)

    batch.add_document sample_add_doc
    bytesize = sample_add_doc.to_json.bytesize
    expect(batch.bytesize).to eq(bytesize)

    batch.delete_document sample_delete_doc
    bytesize += sample_delete_doc.to_json.bytesize
    expect(batch.bytesize).to eq(bytesize)
  end

  it "should not be full" do
    batch.add_document sample_add_doc
    expect(batch.full?).to be_falsy

    batch.delete_document sample_add_doc
    expect(batch.full?).to be_falsy
  end

  it "should clear" do
    clear_batch = AWSCloudSearch::DocumentBatch.new
    clear_batch.add_document sample_add_doc
    clear_batch.delete_document sample_delete_doc

    expect(clear_batch.bytesize > 0).to be_truthy
    expect(clear_batch.size > 0).to be_truthy

    clear_batch.clear

    expect(clear_batch.bytesize).to eq(0)
    expect(clear_batch.size).to eq(0)
  end

  context "#empty?" do
    it "should return true when the batch contains no documents" do
      expect(batch.empty?).to be_truthy
    end

    it "should return false when the batch contains documents to add" do
      batch.add_document sample_add_doc
      expect(batch.empty?).to be_falsy
    end

    it "should return false when the batch contains documents to delete" do
      batch.delete_document sample_delete_doc
      expect(batch.empty?).to be_falsy
    end
  end
end
