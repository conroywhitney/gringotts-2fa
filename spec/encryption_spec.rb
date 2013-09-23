require 'gringotts'

describe Gringotts::Encryption do
  it "should sign using secret key" do
    Gringotts::Encryption.sign("something").should eql("d162b3612a7ca7303c17ce9ca8ada156087e7ae7")
  end
end