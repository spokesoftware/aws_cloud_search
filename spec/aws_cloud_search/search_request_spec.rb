require 'spec_helper'

describe AWSCloudSearch::SearchResponse do
  let(:search_req) { AWSCloudSearch::SearchRequest.new }

  context "#add_facet_top_n" do
    it "should raise ArgumentError when param is not an Integer" do
      expect { search_req.add_facet_top_n("fieldname", "string") }.to raise_error(ArgumentError)
    end
  end

  context "#ad_t" do
    it "should raise ArgumentError when range beginning and end are nil" do
      expect {search_req.add_t("fieldname", nil, nil)}.to raise_error(ArgumentError)
    end

    it "should raise ArgumentError when t_from or t_to are not an Integers" do
      expect {search_req.add_t("fieldname", "string", 10)}.to raise_error(ArgumentError)
      expect {search_req.add_t("fieldname", 10, "string")}.to raise_error(ArgumentError)
      expect {search_req.add_t("fieldname", "string", "string")}.to raise_error(ArgumentError)
    end
  end

  context "#to_hash" do
    it "should return an empty hash" do
      search_req.to_hash.should eq({})
    end
  end

end
