require 'spec_helper'

# These tests requires that your domain index contains the following fields:
# - name: text
# - type: text
# - summary: text
# - num_links: uint
describe AWSCloudSearch::CloudSearch do

  let(:ds) { AWSCloudSearch::CloudSearch.new(ENV['CLOUDSEARCH_DOMAIN']) }

  it "should send document batch" do
    batch = AWSCloudSearch::DocumentBatch.new
    
    doc1 = AWSCloudSearch::Document.new(true)
    doc1.id = Array.new( 8 ) { rand(256) }.pack('C*').unpack('H*').first
    doc1.lang = 'en'
    doc1.add_field('name', 'Jane Williams')
    doc1.add_field('type', 'person')

    doc2 = AWSCloudSearch::Document.new(true)
    doc2.id = Array.new( 8 ) { rand(256) }.pack('C*').unpack('H*').first
    doc2.lang = 'en'
    doc2.add_field :name, 'Bob Dobalina'
    doc2.add_field :type, 'person'

    batch.add_document doc1
    batch.add_document doc2
    ds.documents_batch(batch)
  end

  it "should delete a document" do
    id = 'joeblotzdelete_test'
    batch1 = AWSCloudSearch::DocumentBatch.new
    doc1 = AWSCloudSearch::Document.new(true)
    doc1.id = id
    doc1.lang = 'en'
    doc1.add_field('name', 'Joe Blotz Delete Test')
    doc1.add_field('type', 'person')
    batch1.add_document doc1
    ds.documents_batch(batch1)

    batch2 = AWSCloudSearch::DocumentBatch.new
    doc2 = AWSCloudSearch::Document.new(true)
    doc2.id = id
    batch2.delete_document doc2
    ds.documents_batch(batch2)
  end

  it "should raise ArgumentError for invalid XML 1.0 chars" do
    batch = AWSCloudSearch::DocumentBatch.new

    doc1 = AWSCloudSearch::Document.new(true)
    id = Time.now.to_i.to_s
    doc1.id = id
    doc1.lang = 'en'
    doc1.add_field('name', "Jane Williams")
    doc1.add_field('type', 'person')

    # \\uD800 is not a valid UTF-8 and it this line of code may cause your debugger to break
    expect {doc1.add_field("summary", "This is a REALLY bad char, not even UTF-8 acceptable: \uD800")}.to raise_error(ArgumentError)

    #expect { batch.add_document doc1 }.to raise_error(ArgumentError)

    doc2 = AWSCloudSearch::Document.new(true)
    id = Time.now.to_i.to_s
    doc2.id = id
    doc2.lang = 'en'
    doc2.add_field('name', "Brian Williams")
    doc2.add_field('type', 'person')
    expect {doc2.add_field("summary", "This is a bad char for XML 1.0: \v")}.to raise_error(ArgumentError)

    doc2.instance_variable_get("@fields")['how_did_i_get_here'] = "This is a bad char for XML 1.0: \ufffe"
    expect { batch.add_document doc2 }.to raise_error(ArgumentError)

  end



  it "should return a DocumentBatcher instance for new_batcher" do
    ds.new_batcher.should be_an(AWSCloudSearch::DocumentBatcher)
  end

  it "should search" do
    sr = AWSCloudSearch::SearchRequest.new
    sr.bq = "(and name:'Jane')"
    sr.return_fields = %w(logo_url name type)
    sr.size = 10
    sr.start = 0
    sr.results_type = 'json'

    res = ds.search(sr)

    res.should be_an(AWSCloudSearch::SearchResponse)
  end

end
