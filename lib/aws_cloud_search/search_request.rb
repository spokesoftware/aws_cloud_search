module AWSCloudSearch
  class SearchRequest

    attr_accessor :q, :bq, :rank, :results_type, :return_fields, :size, :start, :facet
    attr_accessor :facet_constraints, :facet_sort, :facet_top_n, :t

    def initialize
      @facet_constraints, @facet_sort, @facet_top_n, @t = {}, {}, {}, {}
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

    # Returns the hash of all the values for this SearchRequest. Useful for creating URL params.
    # @return [Hash] The object converted to a Hash
    def to_hash
      hash = {}
      hash['q']     = @q unless @q.nil?
      hash['bq']    = @bq unless @bq.nil?
      hash['rank']  = @rank unless @rank.nil?
      hash['size']  = @size unless @size.nil?
      hash['start'] = @start unless @start.nil?
      hash['results-type']  = @results_type unless @results_type.nil?
      hash['return-fields'] = @return_fields.join(',') unless @return_fields.nil?
      hash['facet'] = @facet unless @facet.nil?
      hash.merge(@facet_constraints).merge(@facet_sort).merge(@facet_top_n).merge(@t)
    end

  end
end