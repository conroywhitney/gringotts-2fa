module Gringotts
  class Utils
   
    def self.hash_to_qs(hash)
      return hash.collect{|k,v| "#{k}=#{v}"}.join("&")
    end
    
  end
end