require 'spec_helper'

describe DMS::Node do
  describe ".default_params" do
    subject { DMS::Node.default_params }
    context "with default settings" do
      its(:size) { should == 1 }
      its(:keys) { should == [:api_token] }
      its(:values) { should == [""] }
    end
  end
  
  describe ".slug_to_path" do
    it "appends '.xml'" do
      DMS::Node.slug_to_path("documents/1-foobar").should match /\.xml$/
    end
    
    it "prepends a '/'" do
      DMS::Node.slug_to_path("documents/1-foobar").should match /^\/{1}/
    end
    
    context "when slug is nil" do
      it "does not raise an error" do
        lambda { DMS::Node.slug_to_path(nil) }.should_not raise_error
      end
    end
    
    context "when slug is blank" do
      it "does not raise an error" do
        lambda { DMS::Node.slug_to_path('') }.should_not raise_error
      end
    end
    
    context "when slug includes a trailing '/'" do
      it "does not prepend another '/'" do
        DMS::Node.slug_to_path("/documents/1-foobar").should_not match /^\/{2}/
      end
    end
  end
  
  describe ".generate_signature" do
    before(:each) do
      DMS.config[:api_token] = "71e49b70c5f5012dda13002332b13ba0"
      DMS.config[:api_access_key] = "24xPxvzEgXPa5eWW7ZTirQqVt1g3NkVil5UYLUnx"
      @timestamp = "12345567890"
    end
    
    it "correctly generates the signature" do
      DMS::Node.generate_signature(:get, 'foo', @timestamp).should == "omfvZVlOncdqPsyLa1e5/0feDgc="
    end
  end
  
  describe ".find" do
    it "calls .get with the correct path generated from the slug as the first parameter" do
      slug = "documents/1-foobar"
      path = DMS::Node.slug_to_path(slug)
      response = mock(HTTParty::Response, :parsed_response => {})
      
      DMS::Node.should_receive(:get).once.with(path, anything()).and_return(response)
      DMS::Node.find(slug)
    end
    
    it "calls .get with a query hash as a second parameter that includes the timestamp" do
      slug = "documents/1-foobar"
      timestamp = "12345567890"
      response = mock(HTTParty::Response, :parsed_response => {})
      DMS::Node.stub(:generate_timestamp).and_return(timestamp)
      
      DMS::Node.should_receive(:get).once.with(anything(), {:query => hash_including(:timestamp => timestamp)}).and_return(response)
      DMS::Node.find(slug)
    end
    
    it "calls .get with a query hash as a second parameter that includes the signature" do
      slug = "documents/1-foobar"
      signature = "dfhdskf12109231203ssdfsflksdjfl23klddsk"
      response = mock(HTTParty::Response, :parsed_response => {})
      DMS::Node.stub(:generate_signature).and_return(signature)
      
      DMS::Node.should_receive(:get).once.with(anything(), { :query => hash_including(:signature => signature) }).and_return(response)
      DMS::Node.find(slug)
    end
    
    context "when slug is nil" do
      it "raises an error" do
        lambda { DMS::Node.find(nil) }.should raise_error("slug can't be blank!")
      end
    end
    
    context "when slug is blank" do
      it "raises an error" do
        lambda { DMS::Node.find('') }.should raise_error("slug can't be blank!")
      end
    end
  end
end