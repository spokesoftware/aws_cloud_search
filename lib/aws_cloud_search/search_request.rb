module AwsCloudSearch
  class SearchRequest

    attr_accessor :q, :bq, :rank, :results_type, :return_fields, :size, :start

    def to_hash
      hash = {}
      hash['q']     = @q unless @q.nil?
      hash['bq']    = @q unless @bq.nil?
      hash['rank']  = @q unless @rank.nil?
      hash['size']  = @q unless @size.nil?
      hash['start'] = @q unless @start.nil?
      hash['results-type']  = @q unless @results_type.nil?
      hash['return-fields'] = @q unless @return_fields.nil?
      hash
    end

  end
end