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

    expect(sr.found).to eq(1)
    expect(sr.start).to eq(0)
    expect(sr.cpu_time_ms).to eq(0)
    expect(sr.time_ms).to eq(2)
    expect(sr.rid).to eq('6ddcaa561c05c4cc221cb551e21a9631b979b9aa5297fab17731a8b9f863b20423151ddcd9b246caee73334112c96801')

  end
end
