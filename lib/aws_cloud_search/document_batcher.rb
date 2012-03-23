require "yajl/json_gem"
require "aws_cloud_search"

module AwsCloudSearch
  # Convenience method that will allow continuous batch additions and will chunk to a size threshold
  # and send requests for each chunk.
  class DocumentBatcher

    def initialize(domain, region="us-east-1")
      @batch = DocumentBatch.new
      @cs = CloudSearch.new(domain, region)
    end

    def add_document(doc)
      flush if @batch.full?

      @batch.add_document doc
    end

    def delete_document(doc)
      flush if @batch.full?

      @batch.delete_document doc
    end

    def flush
      @cs.documents_batch @batch
      @batch.clear
    end

  end

end