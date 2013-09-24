module Gringotts
  class Request
    
    attr_accessor :url, :uri
    
    def initialize(path)
      # path must be SOMETHING
      raise "Incoming path was nil" if path.nil?
      
      # all incoming paths should be relative
      # we will be determining the base_url, thank you very much
      raise "Incoming path should be relative" unless path.chars.first == "/"
      
      # path should have ? in it already, or add one
      path += "?" unless path.include?("?")

      self.url    = self.base_url + path
      self.uri    = URI.parse(url)
    end
    
    def base_url
      return "#{self.protocol}://#{Gringotts.config.endpoint}/v#{Gringotts.config.api_version}/#{Gringotts.config.account}"
    end
    
    def protocol
      return ["production", "staging"].include?(Gringotts::Config.env) ? "https" : "http"
    end
    
    def secure_url
      return sign(nonce(timestamp(self.url))) 
    end
    
    def timestamp(url)
      return url + "timestamp=#{Time.now.to_i}&"
    end
    
    def nonce(url)
      return url + "nonce=#{rand(999999999)}&"
    end
    
    def sign(url)
      return url + "sig=" + Gringotts::Encryption.sign(url)
    end

  end
end