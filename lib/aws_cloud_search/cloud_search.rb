require "yajl/json_gem"
require "aws_cloud_search"

module AwsCloudSearch
  # TODO: (dj) refactor into class CloudSearch
  class CloudSearch

    def initialize(domain, region="us-east-1")
      @doc_conn = AwsCloudSearch::create_connection( AwsCloudSearch::document_url(domain, region) )
      @search_conn = AwsCloudSearch::create_connection( AwsCloudSearch::search_url(domain, region) )
    end

    # Sends a batch of document updates and deletes by invoking the CloudSearch documents/batch API
    # @param [DocumentBatch] doc_batch The batch of document adds and deletes to send
    # @return
    def documents_batch(doc_batch)
      raise ArgumentError.new("Invalid argument. Expected DocumentBatch, got #{doc_batch.class}.") unless doc_batch.is_a? DocumentBatch

      resp = @doc_conn.post do |req|
        req.url "/#{AwsCloudSearch::API_VERSION}/documents/batch"
        req.headers['Content-Type'] = 'application/json'
        req.body = doc_batch.to_json
      end
      raise(Exception, "AwsCloudSearchCloud::DocumentService batch returned #{resp.body[:errors].size} errors: #{resp.body[:errors].join(';')}") if resp.body[:status] == 'error'
      resp.body
    end

    # Performs a search
    # @param [SearchRequest] search_req
    # @return
    def search(search_req)
      raise ArgumentError.new("Invalid Type: search_request must be of type SearchRequest") unless search_req.is_a? SearchRequest

      query = search_req.to_query_string
      resp = @conn.get do |req|
        req.url "/#{AwsCloudSearch::API_VERSION}/search", search_req.to_hash
      end
      resp.body
    end

    # Build a DocumentBatcher linked to this CloudSearch domain
    # @return [DocumentBatcher]
    def new_batcher
      DocumentBatcher.new(self)
    end

  end
end
