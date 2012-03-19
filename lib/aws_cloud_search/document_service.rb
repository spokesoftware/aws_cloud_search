require "yajl/json_gem"
require "aws_cloud_search"

module AwsCloudSearch
  class DocumentService

    def initialize(domain, region="us-east-1")
      @batch_add = []
      @batch_delete = []
      @conn = AwsCloudSearch::create_connection( AwsCloudSearch::document_url(domain, region) )
    end

    def add_document(doc)
      doc.type = 'add'
      @batch_add << doc
    end

    # Adds a delete document operation to the batch. Removes lang and fields from the object as they are not
    # required for delete operations.
    # @param [Document] doc The document to delete
    def delete_document(doc)
      doc.type = 'delete'
      doc.lang = nil
      doc.clear_fields
      @batch_delete << doc
    end

    # Sends the batch of document updates and deletes
    def send_batch
      json = (@batch_add + @batch_delete).map {|item| item.to_hash}.to_json

      resp = @conn.post do |req|
        req.url "/#{AwsCloudSearch::API_VERSION}/documents/batch"
        req.headers['Content-Type'] = 'application/json'
        req.body = json
      end
      raise(Exception, "AwsCloudSearchCloud::DocumentService batch returned #{resp.body[:errors].size} errors: #{resp.body[:errors].join(';')}") if resp.body[:status] == 'error'
    end

    def batch_size
      @batch_add.size + @batch_delete.size
    end

  end
end