module Gringotts
  class Encryption
    
    def self.sign(something)
      return Digest::HMAC.hexdigest(something, Gringotts.config.secret, Digest::SHA1)
    end
    
  end
end