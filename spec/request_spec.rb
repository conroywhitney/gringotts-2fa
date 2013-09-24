require 'spec_helper'
require 'gringotts'

describe Gringotts::Request do
  
  before(:each) do
    @request = Gringotts::Request.new("/")
  end
  
  it "should...make a base URL..." do
    @request.base_url.should == "http://localhost:3000/v0/testing123"
  end
  
  it "should bomb for nil paths" do
    expect { @request = Gringotts::Request.new(nil) }.to raise_error("Incoming path was nil")
  end
  
  it "should bomb for non-relative paths" do
    expect { @request = Gringotts::Request.new("http://something.absolute.com") }.to raise_error("Incoming path should be relative")
  end
  
  it "should use HTTPS protocol in production" do
    ENV["RACK_ENV"] = "production"
    @request.protocol.should == "https"
  end
  
  it "should use HTTPS protocol in staging" do
    ENV["RACK_ENV"] = "staging"
    @request.protocol.should == "https"
  end
  
  it "should use HTTP protocol in test (local)" do
    ENV["RACK_ENV"] = "test"
    @request.protocol.should == "http"
  end
  
  it "should use HTTP protocol in development (local)" do
    ENV["RACK_ENV"] = "development"
    @request.protocol.should == "http"
  end
  
  it "should return a secure url when you ask for one? (wow, i'm getting tired)" do
    @request = Gringotts::Request.new("/path/to/something.js")
    secure_url = @request.secure_url
    secure_url.include?("timestamp").should == true
    secure_url.include?("nonce").should == true
    secure_url.include?("sig").should == true
  end
  
  it "should add a ? if not exists" do
    @request = Gringotts::Request.new("/path/without/questionmark")
    @request.url.include?("?").should == true
  end
  
end