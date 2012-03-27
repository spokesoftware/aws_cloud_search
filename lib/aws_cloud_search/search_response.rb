module AwsCloudSearch
  class SearchResponse
    attr_reader :response
    attr_reader :hits

    alias :results :hits

    FIELDS = [ :match_expr, :rank, :cpu_time_ms, :time_ms, :rid, :found, :start, :error, :messages ].freeze
    FIELDS.each { |f| attr_accessor f }

    # Takes in the hash, representing the json object returned from a search request
    def initialize(response)
      @response = response

      FIELDS.each do |f|
        fs = f.to_s.gsub('_' , '-')
        val = @response[fs] || @response['info'][fs] || @response['hits'][fs]
        self.instance_variable_set "@#{f}", val
      end

      @hits = @response['hits']['hit']
    end

    def result_size
      @hits.size
    end


  end
end
