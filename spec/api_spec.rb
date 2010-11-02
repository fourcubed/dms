require 'spec_helper'

describe DMS::API do
  let(:responses) { YAML::load(File.open(File.join(File.dirname(__FILE__), 'fixtures', 'responses.yml'))) }
  
  before(:each) do
    stub_request(:get, /dms\.fourcubed\.com/).to_return(responses[200])
    @api = DMS::API.new("123456token", "123456key")
  end
  
  describe "#get" do
    it "calls #perform_request once with the slug" do
      slug = "documents/1-foobar"
      response = mock(HTTParty::Response, :code => 200, :parsed_response => { :document => {} })
      @api.should_receive(:perform_request).once.with(slug).and_return(response)
      @api.get(slug) 
    end
    
    context "when the response has a status code of 200" do
      before(:each) do
        stub_request(:get, /dms\.fourcubed\.com/).to_return(responses[200])
      end
      
      it "returns an instance of DMS::Node" do
        @api.get("documents/1-foobar").should be_an_instance_of(DMS::Node)
      end
    end
    
    context "when the response has a status code of 401" do
      before(:each) do
        stub_request(:get, /dms\.fourcubed\.com/).to_return(responses[401])
      end
      
      it "raises DMS::AuthenticationError" do
        lambda { @api.get("documents/1-foobar") }.should raise_error(DMS::AuthenticationError)
      end
    end
    
    context "when the response has a status code of 404" do
      before(:each) do
        stub_request(:get, /dms\.fourcubed\.com/).to_return(responses[404])
      end
      
      it "raises DMS::ResourceNotFound" do
        lambda { @api.get("documents/1-foobar") }.should raise_error(DMS::ResourceNotFound)
      end
    end
    
    context "when the response has status code of 500" do
      before(:each) do
        stub_request(:get, /dms\.fourcubed\.com/).to_return(responses[500])
      end
      
      it "raises DMS::UnknownError" do
        lambda { @api.get("documents/1-foobar") }.should raise_error(DMS::UnknownError)
      end
    end
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
      @api.send(:generate_signature, :get, 'foo', @timestamp).should == "omfvZVlOncdqPsyLa1e5/0feDgc="
    end
  end
  
  describe "#perform_request" do
    it "returns an instance of HTTParty::Response" do
      @api.send(:perform_request, "documents/1-foo").class == HTTParty::Response
    end
    
    it "calls DMS::API.get with the correct path generated from the slug as the first parameter" do
      slug = "documents/1-foobar"
      path = @api.slug_to_path(slug)
      
      DMS::API.should_receive(:get).once.with(path, anything())
      @api.send(:perform_request, slug)
    end
    
    it "calls .get with a query hash as a second parameter that includes the api_token" do
      slug = "documents/1-foobar"
      
      DMS::API.should_receive(:get).once.with(anything(), {:query => hash_including(:api_token => @api.api_token)})
      @api.send(:perform_request, slug)
    end
    
    it "calls .get with a query hash as a second parameter that includes the timestamp" do
      slug = "documents/1-foobar"
      timestamp = "12345567890"
      @api.stub(:generate_timestamp).and_return(timestamp)
      
      DMS::API.should_receive(:get).once.with(anything(), {:query => hash_including(:timestamp => timestamp)})
      @api.send(:perform_request, slug)
    end
    
    it "calls .get with a query hash as a second parameter that includes the signature" do
      slug = "documents/1-foobar"
      signature = "dfhdskf12109231203ssdfsflksdjfl23klddsk"
      @api.stub(:generate_signature).and_return(signature)
      
      DMS::API.should_receive(:get).once.with(anything(), { :query => hash_including(:signature => signature) })
      @api.send(:perform_request, slug)
    end
    
    context "when slug is nil" do
      it "raises an error" do
        lambda { @api.send(:perform_request, nil) }.should raise_error("slug can't be blank!")
      end
    end
    
    context "when slug is blank" do
      it "raises an error" do
        lambda { @api.send(:perform_request, '') }.should raise_error("slug can't be blank!")
      end
    end
  end
end