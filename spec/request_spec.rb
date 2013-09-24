require 'spec_helper'
require 'gringotts'

describe Gringotts::Request do
  
  before(:each) do
    @request = Gringotts::Request.new
  end
  
  it "should...make a base URL..." do
    @request.base_url.should == "http://localhost:3000/v0/testing123"
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
  
end