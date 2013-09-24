# adapted from https://github.com/assaf/vanity/
module Gringotts

  # Config holds the Gringotts configuration.
  class Config
    
    attr_accessor :endpoint, :api_version, :account, :secret    
    
    DEFAULTS = { 
      :endpoint => nil,
      :api_version => 0,
      :account => nil,
      :secret => nil
    }
    
    SESSION_KEY_EXPIRATION   = :gringotts_expiration
    SESSION_KEY_VERIFICATION = :gringotts_verification
    ROUTE_VERIFY = '/authentication/verify'
    
    def initialize(filename = "gringotts.yml")          
      begin
        if config_file_exists?
          env = ENV["RACK_ENV"] || ENV["RAILS_ENV"] || "development"
          config = load_config_file(filename)[env]
          if Hash === config
            config = config.inject({}) { |h,kv| h[kv.first.to_sym] = kv.last ; h }
          else
            raise "Config file (#{config_file_root}/#{filename}) is either not correct YAML or is lacking environment [#{env}]. Aborting."
          end
        end
      rescue Errno::ENOENT => e
        raise "Config file (#{config_file_root}/#{filename}) does not exist. Aborting."
      end

      @options = DEFAULTS.merge(config)

      @endpoint = @options[:endpoint]
      @api_version = @options[:api_version]
      @account = @options[:account]
      @secret = @options[:secret]
    end
    
    def base_url
      return "https://#{endpoint}/#{version}/#{account_token}"
    end
    
    def config_file_root
      (defined?(::Rails) ? ::Rails.root : Pathname.new(".")) + "config"
    end

    def config_file_exists?(basename = "gringotts.yml")
      File.exists?(config_file_root + basename)
    end

    def load_config_file(basename = "gringotts.yml")
      YAML.load(ERB.new(File.read(config_file_root + basename)).result)
    end
    
  end # Config
  
end # Gringotts