require 'gringotts'

describe Gringotts::Session do
    
  it "should fail if session is blank" do
    Gringotts::Session.valid?({}).should == false
  end
  
  it "should fail if expiration is missing" do
    Gringotts::Session.valid?(Gringotts::Session.signed_session({})).should == false
  end
  
  it "should fail if signature is missing" do
    Gringotts::Session.valid?({ Gringotts::Session::EXPIRATION => (Time.now.to_i + 100000) }).should == false
  end
  
  it "should fail if expiration is old" do
    session = {
      Gringotts::Session::EXPIRATION => (Time.now.to_i - 1).to_i
    }
    Gringotts::Session.valid?(Gringotts::Session.signed_session(session)).should == false
  end
  
  it "should actually encrypt/sign the signature, not provide it plaintext" do
    Gringotts::Session.sign({:harry => "potter"}).include?("harry").should == false
  end
  
  it "should fail if signature is incorrect" do
    incorrectly_signed_session = {
      Gringotts::Session::EXPIRATION => (Time.now.to_i - 1).to_i,
      Gringotts::Session::SIGNATURE  => "quientusabes"
    }
    Gringotts::Session.valid?(incorrectly_signed_session).should == false    
  end
  
  it "should pass if both are y4y" do
    session = {
      Gringotts::Session::EXPIRATION => (Time.now.to_i + 100000).to_i
    }
    Gringotts::Session.valid?(Gringotts::Session.signed_session(session)).should == true
  end
  
end