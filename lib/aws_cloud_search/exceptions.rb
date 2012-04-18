module AWSCloudSearch
  # CloudSearch API errors
  class AwsCloudSearchError < StandardError; end
  class WildcardTermLimit < AwsCloudSearchError; end
  class InvalidFieldOrRankAliasInRankParameter < AwsCloudSearchError; end
  class UnknownFieldInMatchExpression < AwsCloudSearchError; end
  class IncorrectFieldTypeInMatchExpression < AwsCloudSearchError; end
  class InvalidMatchExpression < AwsCloudSearchError; end
  class UndefinedField < AwsCloudSearchError; end

  # HTTP errors
  class UnexpectedHTTPException < StandardError; end
  class HttpClientError < StandardError; end
  class HttpServerError < StandardError; end
  class RequestTimeout < HttpClientError; end
  class BandwidthLimitExceeded < HttpServerError; end
end