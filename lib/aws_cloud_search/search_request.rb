module AwsCloudSearch
  class SearchRequest

    attr_accessor :q, :bq, :rank, :results_type, :return_fields, :size, :start

    def to_hash
      {
        'q' => @q,
        'bq' => @bq,
        'rank' => @rank,
        'results-type' => @results_type,
        'return-fields' => @return_fields,
        'size' => @size,
        'start' => @start
      }
    end

  end
end