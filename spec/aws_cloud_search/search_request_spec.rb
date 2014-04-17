require 'spec_helper'

describe AWSCloudSearch::SearchRequest do
  let(:search_req) { AWSCloudSearch::SearchRequest.new }

  context "#add_facet_top_n" do
    it "should raise ArgumentError when param is not an Integer" do
      expect { search_req.add_facet_top_n("fieldname", "string") }.to raise_error
    end
  end

  context "#add_t" do
    it "should raise ArgumentError when range beginning and end are nil" do
      expect {search_req.add_t("fieldname", nil, nil)}.to raise_error
    end

    it "should raise ArgumentError when t_from or t_to are not Integers" do
      expect {search_req.add_t("fieldname", "string", 10)}.to raise_error
      expect {search_req.add_t("fieldname", 10, "string")}.to raise_error
      expect {search_req.add_t("fieldname", "string", "string")}.to raise_error
    end
  end

  context "#to_hash" do
    it "should return an empty hash" do
      search_req.to_hash.should eq({})
    end
  end

  context "different api version" do

    it "should allow certain methods to only work in api version 2011-02-01" do

      AWSCloudSearch.configure do |config|
        config.api_version = '2011-02-01'
      end

      expect { search_req.bq = "blah"}.not_to raise_error
      expect { search_req.results_type = "blah" }.not_to raise_error

      expect { search_req.query_parser = "blah" }.to raise_error
      expect { search_req.format = "blah" }.to raise_error
    end

    it "should allow certain methods to only work in api version 2013-01-01" do

      AWSCloudSearch.configure do |config|
        config.api_version = '2013-01-01'
      end

      expect { search_req.query_parser = "blah"}.not_to raise_error
      expect { search_req.format = "blah" }.not_to raise_error

      expect { search_req.bq = "blah" }.to raise_error
      expect { search_req.results_type = "blah" }.to raise_error
    end

  end

end
