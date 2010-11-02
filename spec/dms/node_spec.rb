require 'spec_helper'

describe DMS::Node do
  let(:responses) { YAML::load(file_fixture("responses.yml")) }
  
  before(:each) do
    stub_request(:get, /dms\.fourcubed\.com/).to_return(responses[200])
    @api = DMS::API.new("123456token", "123456key")
  end
  
  describe "#initialize" do
    context "when a valid HTTParty::Response instance is passed" do
      before(:each) do
        @response = @api.send(:perform_request, "documents/1-foobar")
      end
      
      it "sets the @name value correct" do
        @node = DMS::Node.new(@response)
        @node.name.should == "Foobar"
      end
      
      it "sets the @type value correct" do
        @node = DMS::Node.new(@response)
        @node.type.should == "Document"
      end
      
      it "sets the @text value correct" do
        @node = DMS::Node.new(@response)
        @node.text.should == "This is the body"
      end
      
      it "sets the @html value correct" do
        @node = DMS::Node.new(@response)
        @node.html.should == "<p>This is the body</p>"
      end
    end
  end
end