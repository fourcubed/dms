require 'spec_helper'

describe DMS do
  it "has a default blank value for config[:api_access_key]" do
    DMS.config[:api_access_key].should be_blank
  end
  
  it "has a default blank value for config[:api_token]" do
    DMS.config[:api_token].should be_blank
  end
  
  it "has DMS Web app domain name as the default value for config[:base_uri]" do
    DMS.config[:base_uri].should == "http://dms.fourcubed.com"
  end
end