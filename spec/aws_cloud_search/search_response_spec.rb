require 'spec_helper'

describe AWSCloudSearch::SearchResponse do
  before(:each) do
    @res1 = {
        'hits' => {
          'found' => 1,
          'start' => 0,
          'hit' => [
            { 'id' => '2e'}
          ]
        },
        'info' => {
          'cpu-time-ms' => 0,
          'time-ms' => 2,
          'rid' => '6ddcaa561c05c4cc221cb551e21a9631b979b9aa5297fab17731a8b9f863b20423151ddcd9b246caee73334112c96801'
        }
    }
  end

  it "should initialize from hash" do
    sr = AWSCloudSearch::SearchResponse.new(@res1)

    sr.found.should eq(1)
    sr.start.should eq(0)
    sr.cpu_time_ms.should eq(0)
    sr.time_ms.should eq(2)
    sr.rid.should eq('6ddcaa561c05c4cc221cb551e21a9631b979b9aa5297fab17731a8b9f863b20423151ddcd9b246caee73334112c96801')

  end
end