module AWSCloudSearch
  class SearchResponse
    attr_reader :response
    attr_reader :hits

    alias :results :hits

    # error is an undocumented field that occurs when an error is returned
    FIELDS = [ :match_expr, :rank, :cpu_time_ms, :time_ms, :rid, :found, :start, :error, :messages, :facets ].freeze
    FIELDS.each { |f| attr_accessor f }

    # Takes in the hash, representing the json object returned from a search request
    def initialize(response)
      @response = response

      FIELDS.each do |f|
        fs = f.to_s.gsub('_' , '-')
        if @response.has_key? 'info' and @response['info'][fs]
          val = @response['info'][fs]
        elsif @response.has_key? 'hits' and @response['hits'][fs]
          val = @response['hits'][fs]
        else
          val = @response[fs]
        end
        self.instance_variable_set "@#{f}", val unless val.nil?
      end

      @hits = @response['hits']['hit'] if @response.has_key? 'hits'
    end

    def result_size
      @hits ? @hits.size : 0
    end


  end
end
