module AWSCloudSearch
  class SearchRequest

    attr_accessor :q, :bq, :rank, :results_type, :return_fields, :size, :start

    def to_hash
      hash = {}
      hash['q']     = @q unless @q.nil?
      hash['bq']    = @bq unless @bq.nil?
      hash['rank']  = @rank unless @rank.nil?
      hash['size']  = @size unless @size.nil?
      hash['start'] = @start unless @start.nil?
      hash['results-type']  = @results_type unless @results_type.nil?
      hash['return-fields'] = @return_fields.join(',') unless @return_fields.nil?
      hash
    end

  end
end