require "json"
require "aws_cloud_search"

module AWSCloudSearch
  # Convenience method that will allow continuous batch additions and will chunk to a size threshold
  # and send requests for each chunk.
  class DocumentBatcher

    def initialize(cs)
      @cs = cs
      @batch = DocumentBatch.new
    end

    def add_document(doc)
      flush if @batch.full?

      @batch.add_document doc
    end

    def delete_document(doc)
      flush if @batch.full?

      @batch.delete_document doc
    end

    # Sends the batch of adds and deletes to CloudSearch Search and then clears the current batch.
    # TODO: (dj) implement connection retry logic
    def flush
      @cs.documents_batch @batch
      @batch.clear
    end

  end

end