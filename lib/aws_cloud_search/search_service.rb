module AwsCloudSearch
  # TODO: (dj) refactor into class CloudSearch
  class SearchService

    def initialize(domain, region="us-east-1")
      @conn = AwsCloudSearch::create_connection( AwsCloudSearch::searchs_url(domain, region) )
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

  end
end