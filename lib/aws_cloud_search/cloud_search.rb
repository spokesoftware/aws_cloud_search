require "yajl/json_gem"
require "aws_cloud_search"

module AwsCloudSearch
  # TODO: (dj) refactor into class CloudSearch
  class CloudSearch

    def initialize(domain, region="us-east-1")
      @conn = AwsCloudSearch::create_connection( AwsCloudSearch::document_url(domain, region) )
    end

    # Sends a batch of document updates and deletes by invoking the CloudSearch documents/batch API
    def documents_batch(doc_batch)
      raise ArgumentError.new("Invalid argument. Expected DocumentBatch, got #{doc_batch.class}.") unless doc_batch.is_a? DocumentBatch

      resp = @conn.post do |req|
        req.url "/#{AwsCloudSearch::API_VERSION}/documents/batch"
        req.headers['Content-Type'] = 'application/json'
        req.body = doc_batch.to_json
      end
      raise(Exception, "AwsCloudSearchCloud::DocumentService batch returned #{resp.body[:errors].size} errors: #{resp.body[:errors].join(';')}") if resp.body[:status] == 'error'
    end

  end
end