require 'spec_helper'

describe DMS::API do
  before(:each) do
    @api = DMS::API.new
  end
  
  describe "#slug_to_path" do
    it "appends #format_extension" do
      @api.slug_to_path("documents/1-foobar").should match /#{@api.format_extension}$/
    end
    
    it "prepends a '/'" do
      @api.slug_to_path("documents/1-foobar").should match /^\/{1}/
    end
    
    context "when slug is nil" do
      it "does not raise an error" do
        lambda { @api.slug_to_path(nil) }.should_not raise_error
      end
    end
    
    context "when slug is blank" do
      it "does not raise an error" do
        lambda { @api.slug_to_path('') }.should_not raise_error
      end
    end
    
    context "when slug includes a trailing '/'" do
      it "does not prepend another '/'" do
        @api.slug_to_path("/documents/1-foobar").should_not match /^\/{2}/
      end
    end
  end
  
  describe "#generate_signature" do
    before(:each) do
      @api.api_token = "71e49b70c5f5012dda13002332b13ba0"
      @api.api_access_key = "24xPxvzEgXPa5eWW7ZTirQqVt1g3NkVil5UYLUnx"
      @timestamp = "12345567890"
    end
    
    it "correctly generates the signature" do
      @api.generate_signature(:get, 'foo', @timestamp).should == "omfvZVlOncdqPsyLa1e5/0feDgc="
    end
  end
  
  describe "#get" do
    it "calls DMS::API.get with the correct path generated from the slug as the first parameter" do
      slug = "documents/1-foobar"
      path = @api.slug_to_path(slug)
      response = mock(HTTParty::Response)
      
      DMS::API.should_receive(:get).once.with(path, anything()).and_return(response)
      @api.get(slug)
    end
    
    it "calls .get with a query hash as a second parameter that includes the timestamp" do
      slug = "documents/1-foobar"
      timestamp = "12345567890"
      response = mock(HTTParty::Response)
      @api.stub(:generate_timestamp).and_return(timestamp)
      
      DMS::API.should_receive(:get).once.with(anything(), {:query => hash_including(:timestamp => timestamp)}).and_return(response)
      @api.get(slug)
    end
    
    it "calls .get with a query hash as a second parameter that includes the signature" do
      slug = "documents/1-foobar"
      signature = "dfhdskf12109231203ssdfsflksdjfl23klddsk"
      response = mock(HTTParty::Response)
      @api.stub(:generate_signature).and_return(signature)
      
      DMS::API.should_receive(:get).once.with(anything(), { :query => hash_including(:signature => signature) }).and_return(response)
      @api.get(slug)
    end
    
    context "when slug is nil" do
      it "raises an error" do
        lambda { @api.get(nil) }.should raise_error("slug can't be blank!")
      end
    end
    
    context "when slug is blank" do
      it "raises an error" do
        lambda { @api.get('') }.should raise_error("slug can't be blank!")
      end
    end
  end
end