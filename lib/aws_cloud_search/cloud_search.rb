require "json"
require "aws_cloud_search"

module AWSCloudSearch
  class CloudSearch

    def initialize(domain, region="us-east-1")
      @doc_conn = AWSCloudSearch::create_connection( AWSCloudSearch::document_url(domain, region) )
      @search_conn = AWSCloudSearch::create_connection( AWSCloudSearch::search_url(domain, region) )
    end

    # Sends a batch of document updates and deletes by invoking the CloudSearch documents/batch API
    # @param [DocumentBatch] doc_batch The batch of document adds and deletes to send
    # @return
    def documents_batch(doc_batch)
      raise ArgumentError.new("Invalid argument. Expected DocumentBatch, got #{doc_batch.class}.") unless doc_batch.is_a? DocumentBatch

      resp = @doc_conn.post do |req|
        req.url "/#{AWSCloudSearch::API_VERSION}/documents/batch"
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

      resp = @search_conn.get do |req|
        req.url "/#{AWSCloudSearch::API_VERSION}/search", search_req.to_hash
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
