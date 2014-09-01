module AWSCloudSearch
  class SearchRequest

    attr_accessor :q, :rank, :return_fields, :size, :start, :facet
    attr_accessor :facet_constraints, :facet_sort, :facet_top_n, :t

    def initialize
      @facet_constraints, @facet_sort, @facet_top_n, @t, @rank_expressions = {}, {}, {}, {}, {}
    end

    # Specifies the facet constraints for a field
    # @param [String] field The field for which to add the facet constraints
    # @param [String] constraints The facet contraints
    def add_facet_constraints(field, constraints)
      @facet_constraints["facet-#{field}-constraints"] = constraints
    end

    # Specifies how to sort a facet field.
    # @param [String] field The field for which to add the facet sort
    # @param [String] sort The facet sort method: alpha, count, max, sum
    def add_facet_sort(field, sort)
      @facet_sort["facet-#{field}-sort"] = sort
    end

    # Specifies how many facet constraints to return.
    # @param [String] field The field for which to add the facet top n constraints.
    # @param [Integer] top_n The maximum number of facet constraints to add for a field.
    def add_facet_top_n(field, top_n)
      raise ArgumentError.new("top_n must be of type Integer") unless top_n.kind_of? Integer
      @facet_top_n["facet-#{field}-top-n"] = top_n
    end

    # Restricts the records returned based on the values from the rank expression. The t-field value is a range.
    # @param [String] field The field for which to add.
    # @param [Integer] t_from Beginning of the range, may be nil or blank string.
    # @param [Integer] t_to   End of the range, may be nil or blank string.
    def add_t(field, t_from, t_to)
      raise ArgumentError.new("Range must have a beginning or ending value or both.") if t_from.nil? and t_to.nil?
      raise ArgumentError.new("Range values must be of type Integer") unless t_from.kind_of? Integer and t_to.kind_of? Integer
      @t["t-#{field}"] = "#{t_from}..#{t_to}"
    end

    # Adds a query time rank expression to the query. In order to use this rank expression, you are still required to
    # include it in the rank value.
    #
    # All expression names passed to this method are prefixed by 'rank-'
    # For instance passing in 'expression1' will use 'rank-expression1' in the query to AWS CloudSearch.
    #
    # For more information please see:
    # http://docs.aws.amazon.com/cloudsearch/latest/developerguide/rankexpressionquery.html
    #
    # @param [String] expression_name The name of the query time rank expression
    # @param [String] value The rank expression
    def add_rank_expression(expression_name, value)
      @rank_expressions['rank-'+expression_name] = value
    end

    def bq=(str)
      valid_for_api_version!("2011-02-01")
      @bq = str
    end

    def bq
      valid_for_api_version!("2011-02-01")
      @bq
    end

    def results_type=(str)
      valid_for_api_version!("2011-02-01")
      @results_type = str
    end

    def results_type
      valid_for_api_version!("2011-02-01")
      @results_type
    end

    def query_parser=(parser)
      valid_for_api_version!("2013-01-01")
      @query_parser = parser
    end

    def query_parser
      valid_for_api_version!("2013-01-01")
      @query_parser
    end

    def format=(format)
      valid_for_api_version!("2013-01-01")
      @format = format
    end

    def format
      valid_for_api_version!("2013-01-01")
      @format
    end

    # Returns the hash of all the values for this SearchRequest. Useful for creating URL params.
    # @return [Hash] The object converted to a Hash
    def to_hash
      hash = {}
      hash['q']     = @q unless @q.nil?

      hash['rank']  = @rank unless @rank.nil?
      hash['size']  = @size unless @size.nil?
      hash['start'] = @start unless @start.nil?
      hash['results-type']  = @results_type unless @results_type.nil?

      if AWSCloudSearch.config.api_version == '2011-02-01'
        hash['bq']    = @bq unless @bq.nil?
        hash['return-fields'] = @return_fields.join(',') unless @return_fields.nil?
        hash['results-type']  = @results_type unless @results_type.nil?
      elsif AWSCloudSearch.config.api_version == '2013-01-01'
        hash['q.parser'] = @query_parser unless @query_parser.nil?
        hash['return'] = @return_fields.join(',') unless @return_fields.nil?
        hash['format']  = @format unless @format.nil?
      end

      hash['facet'] = @facet unless @facet.nil?
      hash.merge(@facet_constraints).merge(@facet_sort).merge(@facet_top_n).merge(@t).merge(@rank_expressions)
    end

    private

    def valid_for_api_version!(version)
      raise "This parameter is only allowed in API Version #{version}" unless AWSCloudSearch.config.api_version == version
    end

  end
end