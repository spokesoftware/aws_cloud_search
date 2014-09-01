require "json"
require "aws_cloud_search"

module AWSCloudSearch
  class CloudSearch

    def initialize
      @doc_conn = AWSCloudSearch::create_connection( AWSCloudSearch.config.document_url )
      @search_conn = AWSCloudSearch::create_connection( AWSCloudSearch.config.search_url )
    end

    # Sends a batch of document updates and deletes by invoking the CloudSearch documents/batch API
    # @param [DocumentBatch] doc_batch The batch of document adds and deletes to send
    # @param [retry] retry Enable or disable retrying when error or exception is encountered
    # @param [retries] retries The number of times to try posting before raising an exception
    # @return
    def documents_batch(doc_batch, retry_enabled=false, retries=3)
      raise ArgumentError.new("Invalid argument. Expected DocumentBatch, got #{doc_batch.class}.") unless doc_batch.is_a? DocumentBatch
      times = 0
      begin
        return documents_batch_execute(doc_batch)
      rescue Exception => e
        times += 1
        retry if retry_enabled && times < retries
        raise e
      end
    end

    # :nodoc:
    def documents_batch_execute(doc_batch)
      resp = @doc_conn.post do |req|
        req.url "/#{AWSCloudSearch.config.api_version}/documents/batch"
        req.headers['Content-Type'] = 'application/json'
        req.body = doc_batch.to_json
      end

      if resp.body[:status] == 'error'
        raise(StandardError, "AwsCloudSearchCloud::DocumentService batch returned #{resp.body[:errors].size} errors: #{resp.body[:errors].join(';')}")
      end

      return resp.body
    end

    # Performs a search
    # Note that for strings in the search criteria, any single quotation marks or backslashes in the string must
    # be escaped with a backslash.  The #escape method is provided as a convenience to perform the required escaping.
    # @param [SearchRequest] search_req
    # @return
    def search(search_req)
      raise ArgumentError.new("Invalid Type: search_request must be of type SearchRequest") unless search_req.is_a? SearchRequest

      resp = @search_conn.get do |req|
        req.url "/#{AWSCloudSearch.config.api_version}/search", search_req.to_hash
      end

      search_response = SearchResponse.new(resp.body)
      if search_response.error
        raise StandardError.new("Unknown error") if resp.messages.blank?
        code = resp.messages.first['code']
        message = resp.messages.first['message']
        msg = "#{code}: #{message}"
        case code
          when /WildcardTermLimit/
            raise WildcardTermLimit.new(msg)
          when /InvalidFieldOrRankAliasInRankParameter/
            raise InvalidFieldOrRankAliasInRankParameter, msg
          when /UnknownFieldInMatchExpression/
            raise UnknownFieldInMatchExpression, msg
          when /IncorrectFieldTypeInMatchExpression/
            raise IncorrectFieldTypeInMatchExpression, msg
          when /InvalidMatchExpression/
            raise InvalidMatchExpression, msg
          when /UndefinedField/
            raise UndefinedField, msg
          else
            raise AwsCloudSearchError, "Unknown error. #{msg}"
        end
      end

      search_response
    end

    # Build a DocumentBatcher linked to this CloudSearch domain
    # @return [DocumentBatcher]
    def new_batcher
      DocumentBatcher.new(self)
    end

  end
end
