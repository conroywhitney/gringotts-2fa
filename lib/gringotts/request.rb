module Gringotts
  class Request
    
    def initialize
    end
    
    def base_url
      return "#{self.protocol}://#{Gringotts.config.endpoint}/#{Gringotts.config.api_version}/#{Gringotts.config.account}"
    end
    
    def protocol
      return (Gringotts::Config.env == "development") ? "http" : "https"
    end

  end
end