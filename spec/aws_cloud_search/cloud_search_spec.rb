require 'spec_helper'

# These tests requires that your domain index contains the following fields:
# - name: text
# - type: text
# - summary: text
# - num_links: uint
describe AWSCloudSearch::CloudSearch do

  before(:each) do
    AWSCloudSearch.configure do |config|
      config.api_version = '2011-02-01'
      config.region      = 'us-east-1'
      config.domain      = ENV['CLOUDSEARCH_DOMAIN_V2011']
    end
  end

  let(:ds) { AWSCloudSearch::CloudSearch.new }

  it "should send document batch for api version 2011-02-01" do
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

  it "should send document batch for api version 2013-01-01" do

    AWSCloudSearch.configure do |config|
      config.api_version = '2013-01-01'
      config.domain      = ENV['CLOUDSEARCH_DOMAIN_V2013']
    end

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

  it "should delete a document for '2011-02-01' version" do
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

  it "should delete a document for '2013-01-01' version" do

    AWSCloudSearch.configure do |config|
      config.api_version = '2013-01-01'
      config.domain      = ENV['CLOUDSEARCH_DOMAIN_V2013']
    end

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
    expect(ds.new_batcher).to be_a AWSCloudSearch::DocumentBatcher
  end

  it "should search for '2011-02-01' domain version" do
    sr = AWSCloudSearch::SearchRequest.new
    sr.q = "Jane"
    sr.return_fields = %w(logo_url name type)
    sr.size = 10
    sr.start = 0
    sr.results_type = 'json'

    res = ds.search(sr)

    expect(res).to be_a AWSCloudSearch::SearchResponse
  end


  it "should boolean search for '2011-02-01' domain version" do
    sr = AWSCloudSearch::SearchRequest.new
    sr.bq = "(and name:'Jane')"
    sr.return_fields = %w(num_links name type)
    sr.size = 10
    sr.start = 0
    sr.results_type = 'json'

    res = ds.search(sr)

    expect(res).to be_a AWSCloudSearch::SearchResponse
  end

  it "should search for '2013-01-01' domain version" do

    AWSCloudSearch.configure do |config|
      config.api_version = '2013-01-01'
      config.domain      = ENV['CLOUDSEARCH_DOMAIN_V2013']
    end

    sr = AWSCloudSearch::SearchRequest.new
    sr.q = 'Jane'
    sr.return_fields = %w(num_links name type)
    sr.size = 10
    sr.start = 0
    sr.format = 'json'

    res = ds.search(sr)

    expect(res).to be_a AWSCloudSearch::SearchResponse
  end

  it "should structured search for '2013-01-01' domain version" do

    AWSCloudSearch.configure do |config|
      config.api_version = '2013-01-01'
      config.domain      = ENV['CLOUDSEARCH_DOMAIN_V2013']
    end

    sr = AWSCloudSearch::SearchRequest.new
    sr.q = "(and name:'Jane')"
    sr.query_parser = 'structured'
    sr.return_fields = %w(num_links name type)
    sr.size = 10
    sr.start = 0
    sr.format = 'json'

    res = ds.search(sr)

    expect(res).to be_a AWSCloudSearch::SearchResponse
  end


  context "escape" do
    it "should escape backslashes" do
      name = AWSCloudSearch.escape('P\\C\\L Financial Group')
      expect(name).to eql('P\\\\C\\\\L Financial Group')
    end

    it "should escape single quotes" do
      name = AWSCloudSearch.escape('Kellogg\'s')
      expect(name).to eql("Kellogg\\'s")
    end
  end

end
