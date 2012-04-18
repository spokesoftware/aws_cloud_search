require "json"
require "aws_cloud_search"

module AWSCloudSearch
  class DocumentBatch

    attr_reader :bytesize

    # Constructor
    # @param [Integer] pref_bytesize The preferred size of the batch in bytes. May be exceeded, if so batch is considered full.
    # @param [Integer] max_bytesize The batch size in bytes must not exceed this number. Must be greater than pref_bytesize.
    # @raise [ArgumentError] If pref_bytesize is not less than max_bytesize
    def initialize(pref_bytesize=1048576, max_bytesize= 5242880)
      raise ArgumentError.new("pref_bytesize must be less than max_bytesize") if pref_bytesize >= max_bytesize

      @pref_bytesize = pref_bytesize
      @max_bytesize = max_bytesize
      @batch_add = []
      @batch_delete = []
      @bytesize = 0
    end

    # Adds a document with the add operation to the batch.
    # @param [Document] doc
    # @raise [ArgumentError] If parameter is not an AWSCloudSearch::Document
    def add_document(doc)
      raise ArgumentError.new("Invalid Type") unless doc.is_a? Document

      doc.type = 'add'
      json = doc.to_json
      doc_bytesize = json.bytesize

      raise Exception.new("Max batch size exceeded, document add was not added to batch.") if (doc_bytesize + @bytesize) > @max_bytesize
      raise ArgumentError.new("Found invalid XML 1.0 unicode characters.") if json =~ INVALID_CHAR_XML10

      @bytesize += doc_bytesize
      @batch_add << doc
    end

    # Adds a delete document operation to the batch. Removes lang and fields from the object as they are not
    # required for delete operations.
    # @param [Document] doc The document to delete
    # @raise [ArgumentError] If parameter is not an AWSCloudSearch::Document
    # TODO: refactor to only use the required fields, hide the document construction from the user
    def delete_document(doc)
      raise ArgumentError.new("Invalid Type") unless doc.is_a? Document

      doc.type = 'delete'
      doc.lang = nil
      doc.clear_fields
      doc_bytesize = doc.to_json.bytesize

      raise Exception.new("Max batch size exceeded, document delete was not added to batch.") if (doc_bytesize + @bytesize) > @max_bytesize

      @bytesize += doc_bytesize
      @batch_delete << doc
    end

    # @return [Integer] Number of items in the batch
    def size
      @batch_add.size + @batch_delete.size
    end

    # @return [Boolean] True if the bytesize of the batch exceeds the preferred bytesize
    def full?
      @bytesize >= @pref_bytesize
    end

    # @return [String] The JSON string representation of the DocumentBatch
    def to_json
      (@batch_add + @batch_delete).map {|item| item.to_hash}.to_json
    end

    def clear
      @batch_add.clear
      @batch_delete.clear
      @bytesize = 0
    end

  end
end