require 'spec_helper'
require 'gringotts'

describe Gringotts::Persistence do
    
  it "should fail if session is blank" do
    Gringotts::Persistence.valid?({}).should == false
  end
  
  it "should fail if expiration is missing" do
    Gringotts::Persistence.valid?(Gringotts::Persistence.signed_session({})).should == false
  end
  
  it "should fail if signature is missing" do
    Gringotts::Persistence.valid?({ Gringotts::Persistence::EXPIRATION => (Time.now.to_i + 100000) }).should == false
  end
  
  it "should fail if expiration is old" do
    session = {
      Gringotts::Persistence::EXPIRATION => (Time.now.to_i - 1).to_i
    }
    Gringotts::Persistence.valid?(Gringotts::Persistence.signed_session(session)).should == false
  end
  
  it "should actually encrypt/sign the signature, not provide it plaintext" do
    Gringotts::Persistence.sign({:harry => "potter"}).include?("harry").should == false
  end
  
  it "should fail if signature is incorrect" do
    incorrectly_signed_session = {
      Gringotts::Persistence::EXPIRATION => (Time.now.to_i - 1).to_i,
      Gringotts::Persistence::SIGNATURE  => "quientusabes"
    }
    Gringotts::Persistence.valid?(incorrectly_signed_session).should == false    
  end
  
  it "should pass if both are y4y" do
    session = {
      Gringotts::Persistence::EXPIRATION => (Time.now.to_i + 100000).to_i
    }
    Gringotts::Persistence.valid?(Gringotts::Persistence.signed_session(session)).should == true
  end
  
end