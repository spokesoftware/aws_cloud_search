require 'spec_helper'

describe AWSCloudSearch::Document do
  let(:doc) { AWSCloudSearch::Document.new }

  context "#id=" do
    it "should accept a String-able value (Integer)" do
      expect { doc.id = 123456789 }.to_not raise_error
    end
  
    it "should accept a compliant String" do
      expect { doc.id = "abcdef" }.to_not raise_error
    end

    it "should not accept a non-compliant String" do
      expect { doc.id = 'AZ12' }.to raise_error(ArgumentError)
      expect { doc.id = '!@#$%^&*()AZ' }.to raise_error(ArgumentError)
      expect { doc.id = '_abc123' }.to raise_error(ArgumentError)
    end

    it "should not accept nil" do
      expect { doc.id = nil }.to raise_error(ArgumentError)
    end
  end

  context "#type_attr_accessor attributes" do
    it "should accept values of proper type" do
      expect { doc.lang = 'abcd' }.to_not raise_error
      expect { doc.version = 1234 }.to_not raise_error
    end

    it "should not accept values of incorrect type" do 
      expect { doc.lang = 1234 }.to raise_error(ArgumentError)
      expect { doc.version "abcd" }.to raise_error(ArgumentError)
    end
  end

end
