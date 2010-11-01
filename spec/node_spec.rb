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
      DMS::Node.slug_to_path("documents/1-foobar").should match /^\//
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
  end
  
  describe ".find" do
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
    
    it "calls .slug_to_path with the slug" do
      DMS::Node.should_receive(:slug_to_path).with("documents/1-foobar").and_return("/documents/1-foobar.xml")
      DMS::Node.find("documents/1-foobar")
    end
  end
end