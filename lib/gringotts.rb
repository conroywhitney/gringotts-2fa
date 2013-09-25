require "yaml"

require "gringotts/version"
require 'gringotts/config'
require 'gringotts/utils'
require 'gringotts/encryption'
require 'gringotts/session'
require 'gringotts/request'

module Gringotts
  
  attr_accessor :config
  
  def self.config(filename = "gringotts.yml")
    @config = Gringotts::Config.new(filename) if @config.nil?
    return @config
  end
  
  def self.authorization_javascript_url    
    return "" if @gringotts_identity.nil?
    @request = Request.new("/auth/#{@gringotts_identity}.js")
    return @request.secure_signed_url
  end
  
  def self.verified?(session)
    return Gringotts::Session.valid?(session)
  end
  
  def self.identity(object_id)
    return Digest::HMAC.hexdigest(object_id, Gringotts.config.secret, Digest::SHA1)
  end
  
end
