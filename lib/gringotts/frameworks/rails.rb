# adapted from https://github.com/assaf/vanity/
module Gringotts
  module Rails #:nodoc:
    def self.load!
      # Do this at the very end of initialization
      ::Rails.configuration.after_initialize do
        # do ... some things ...
      end
    end
    
    # The use_gringotts method will setup the controller to allow authentication of the current user.
    module GringottsProtego
      # Defines the gringotts_identity method and the set_identity_context filter.
      #
      # Call with the name of a method that returns an object whose identity
      # will be used as the Gringotts identity.  Confusing?  Let's try by example:
      #
      #   class ApplicationController < ActionController::Base
      #     gringotts_protego :current_user
      #
      #     def current_user
      #       User.find(session[:user_id])
      #     end
      #   end
      #
      # If that method (current_user in this example) returns nil, Gringotts will
      # not try to authenticate in any way, because obviously there is no user to authenticate.
      def gringotts_protego(symbol = nil)
        define_method :gringotts_identity do
          return @gringotts_identity if @gringotts_identity
          if symbol && object = send(symbol)
            # encrypt the object identity with our private key
            # that way we never send a plain-text indicator of which user we're authenticating
            # note: this identifier needs to be consistent for each user
            # it's what the server will use to identify who we are trying to authenticate
            @gringotts_identity = Gringotts.identity(object.id)
          elsif response
            # we're handling a real-life scenario, however...
            # there is no object to identify, so we will not do anything
            @gringotts_identity = nil
          else
            # this is a test scenario
            @gringotts_identity = "test"
          end
        end # gringotts_identity
      
        protected :gringotts_identity
        
      end # gringotts_protego
      
      def gringotts_colloportus!
        # can only protect if we know who to protect!
        return if @gringotts_identity.nil?
        
        # protection lies in two session variables
        # 1) tells us how long the protection lasts (expiration)
        # 2) the other confirms that the protection is real (not hijacked)
        
        unless Gringotts.verified?(session)
          redirect_to Gringotts.config.ROUTE_VERIFY
        end
      end        
      
      protected :gringotts_protego, :gringotts_colloportus!
      
    end # UseGringotts
  end # Rails
end # Gringotts


# Enhance ActionController with gringotts_protego
if defined?(ActionController)
  # Include in controller, add view helper methods.
  ActionController::Base.class_eval do
    extend Gringotts::Rails::GringottsProtego
  end
end
