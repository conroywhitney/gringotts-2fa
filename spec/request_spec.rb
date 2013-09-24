require 'spec_helper'
require 'gringotts'

describe Gringotts::Request do
  
  before(:each) do
    @request = Gringotts::Request.new
  end
  
  it "should use HTTPS protocol in production" do
    ENV["RACK_ENV"] = "production"
    @request.protocol.should == "https"
  end
  
end