RSpec.configure do |config|
  config.before(:all) {}
  config.before(:each) {
    ENV["RAILS_ENV"] = nil
    ENV["RACK_ENV"]  = nil
  }
  config.after(:all) {}
  config.after(:each) {}
end