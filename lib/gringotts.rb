require "yaml"

require "gringotts/version"
require 'gringotts/config'
require 'gringotts/utils'
require 'gringotts/encryption'
require 'gringotts/session'

module Gringotts
  
  attr_accessor :config
  
  def self.config(filename = "gringotts.yml")
    return Gringotts::Config.new(filename)
  end
  
  def authorization_javascript_url
    return "" if @gringotts_identity.nil?
    
    # basic request URL for the JS we are going to load
    js_url = "#{Gringotts.base_url}/auth/#{@gringotts_identity}.js?"
    
    # add additional security / informational params to the request
    js_url += {
      :timestamp => Time.now.to_i,
      :nonce => rand(999999999),
    }.to_query
    
    # last but not least, sign the query using our secret key so the server knows it's from us
    js_url += "&sig=" + sign(js_url)
  end
  
  def verified?(session)
    return Gringotts::Session.valid?(session)
  end
  
end
