require 'spec_helper'

describe AwsCloudSearch::Document do
  before(:each) do
    @doc = AwsCloudSearch::Document.new
  end

  it "should accept values of the proper type" do
    expect { @doc.id='123abc' }.to_not raise_error
    expect { @doc.lang='en' }.to_not raise_error
    expect { @doc.version=123 }.to_not raise_error
  end

  it "should throw an exception when given values of the wrong type" do
    expect { @doc.id=123 }.to raise_error(Exception)
    expect { @doc.lang=123 }.to raise_error(Exception)
    expect { @doc.version='abc123' }.to raise_error(Exception)
  end

  it "should reject an incorrectly formatted id" do
    expect { @doc.id='AZ12'}.to raise_error(Exception)
    expect { @doc.id='!@#$%^&*()AZ'}.to raise_error(Exception)
    expect { @doc.id= '_abc123'}.to raise_error(Exception)
  end

end