require 'spec_helper'
require 'gringotts'

describe Gringotts::Config do
 
  it "bombs for a missing YML file" do
    filename = "missing.yml"
    expect { Gringotts.config(filename) }.to raise_error("Config file (config/#{filename}) does not exist. Aborting.")
  end
  
  it "bombs for a badly formed YML file" do
    filename = "badform.yml"
    expect { Gringotts.config(filename) }.to raise_error("Config file (config/#{filename}) is either not correct YAML or is lacking environment [#{Gringotts::Config.env}]. Aborting.")
  end
  
  it "can load existing, correctly-formed gringotts.yml without bombing" do
    expect { Gringotts.config }.to_not raise_error
  end

  it "correctly loads endpoint" do
    Gringotts.config.endpoint.should == "localhost:3000"
  end

  it "correctly loads account" do
    Gringotts.config.account.should == "testing123"
  end
  
  it "correctly loads secret" do
    Gringotts.config.secret.should == "test_sekret"
  end
  
  it "determines env based on RAILS_ENV" do
    ENV["RAILS_ENV"] = "hogwartz"
    Gringotts::Config.env.should == "hogwartz"
  end
  
  it "determines env based on RACK_ENV" do
    ENV["RACK_ENV"] = "pivotdrive"
    Gringotts::Config.env.should == "pivotdrive"
  end
  
  it "defaults env to development" do
    Gringotts::Config.env.should == "development"
  end

end