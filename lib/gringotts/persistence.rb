module Gringotts
  
  class Persistence
    
    EXPIRATION = :gringotts_expiration
    SIGNATURE  = :gringotts_signature
   
    attr_accessor :expiration, :signature
        
    def self.valid?(session)
      @session = self.new(session)
      return !@session.expired? && @session.valid?
    end
    
    def initialize(session)
      # take the relevant variables from the session
      @expiration   = session[EXPIRATION]
      @signature    = session[SIGNATURE]
    end
    
    def expired?
      # check whether the expiration timestamp from the session has expired
      return @expiration.nil? || @expiration < Time.now.to_i
    end
    
    def valid?
      # check to make sure that the variables in the session are actually set by us
      return !@signature.nil? && (@signature == Gringotts::Persistence.sign({
        EXPIRATION => @expiration
      }))
    end
    
    def self.signed_session(session)
      return session.merge({
        SIGNATURE => Gringotts::Persistence.sign(session)
      })
    end
    
    def self.sign(session)
      return Gringotts::Encryption.sign(Gringotts::Utils.hash_to_qs(session))
    end
    
  end
  
end